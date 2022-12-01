//
//  ChattingRoomViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import Foundation

final class ChattingRoomViewModel {
    
    private let sendMessageUseCase: SendMessageUseCase
    private let loadChattingsUseCase: LoadChattingsUseCase
    private let loadUnreadChattingsUseCase: LoadUnreadChattingsUseCase
    private let loadPrevChattingsUseCase: LoadPrevChattingsUseCase
    private let listenOthersChattingsUseCase: ListenOthersChattingUseCase
    private let listenOtherIsReadingUseCase: ListenOtherIsReadingUseCase
    private let imageKeyUseCase: ImageKeyUseCase
    private let fetchImageUseCase: FetchImageUseCase
    
    private var newChattingSet = Set<Chat>()
//
//    var chattings: [Chat] {
//        return loadPrevChattingsUseCase.prevChattings.value
//        + loadChattingsUseCase.initLoadedchattings.value
//        + loadUnreadChattingsUseCase.unreadChattings.value
//        + newChattingSet.sorted { l, r in
//            guard let lDate = l.date, let rDate = r.date else { return true }
//            return lDate < rDate
//        }
//    }
    
    init(
        sendMessageUseCase: SendMessageUseCase,
        loadChattingsUseCase: LoadChattingsUseCase,
        loadUnreadChattingsUseCase: LoadUnreadChattingsUseCase,
        loadPrevChattingsUseCase: LoadPrevChattingsUseCase,
        listenOthersChattingsUseCase: ListenOthersChattingUseCase,
        listenOtherIsReadingUseCase: ListenOtherIsReadingUseCase,
        imageKeyUseCase: ImageKeyUseCase,
        fetchImageUseCase: FetchImageUseCase
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.loadChattingsUseCase = loadChattingsUseCase
        self.loadUnreadChattingsUseCase = loadUnreadChattingsUseCase
        self.loadPrevChattingsUseCase = loadPrevChattingsUseCase
        self.listenOthersChattingsUseCase = listenOthersChattingsUseCase
        self.listenOtherIsReadingUseCase = listenOtherIsReadingUseCase
        self.imageKeyUseCase = imageKeyUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
        var viewWillDisappear: AnyPublisher<Void, Never>
        var message: AnyPublisher<String?, Never>
        var messageSendEvent: AnyPublisher<Void, Never>?
        var loadPrevChattings: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var sendButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var chattingInitLoaded = PassthroughSubject<[Chat], Never>()
        var unreadChattingLoaded = PassthroughSubject<[Chat], Never>()
        var prevChattingLoaded = PassthroughSubject<[Chat], Never>()
        var chatUpdated = PassthroughSubject<Int, Never>()
        var newMessageArrived = PassthroughSubject<Int, Never>()
        var keyboardHeight = KeyboardMonitor().$keyboardHeight        
    }
    
    func fetchProfileImage(of uid: String) async -> Data? {
        guard let key = await imageKeyUseCase.imageKey(from: uid) else { return nil }
        guard let data = await fetchImageUseCase.fetchImage(for: key) else { return nil }
        
        return data
    }
    
    func transform(input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.loadChattingsUseCase.loadChattings()
            }
            .store(in: &cancellables)
        
        input.viewWillDisappear
            .sink { _ in
                self.listenOthersChattingsUseCase.removeListen()
            }
            .store(in: &cancellables)
        
        input.message
            .compactMap { $0 }
            .sink { [weak self] text in                
                self?.sendMessageUseCase.updateMessage(text)
            }
            .store(in: &cancellables)
        
        input.messageSendEvent?
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                self?.sendMessageUseCase.sendMessage()
            }
            .store(in: &cancellables)
        
        input.loadPrevChattings            
            .sink { [weak self] _ in
                self?.loadPrevChattingsUseCase.loadPrevChattings()
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.sendButtonEnabled
            .sink { isEnabled in
                output.sendButtonEnabled.send(isEnabled)
            }
            .store(in: &cancellables)
        
        self.loadChattingsUseCase.initLoadedchattings
            .dropFirst()
            .sink { [weak self] chats in
                output.chattingInitLoaded.send(chats)
                self?.loadUnreadChattingsUseCase.loadUnreadChattings()
            }
            .store(in: &cancellables)
        
        self.loadUnreadChattingsUseCase.unreadChattings
            .sink { [weak self] chats in
                output.unreadChattingLoaded.send(chats)
                self?.listenOthersChattingsUseCase.listenOthersChattings()
//                self?.listenOtherIsReadingUseCase.listenOtherIsReading()
            }
            .store(in: &cancellables)
        
        self.loadPrevChattingsUseCase.loadedPrevChatting
            .sink { chats in
                output.prevChattingLoaded.send(chats)
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.newMessage
            .sink { [weak self] chat in
                self?.newChattingSet.insert(chat)
                output.newMessageArrived.send(1)
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.messageSended
        
            .sink { [weak self] result in
                let id = result.id
                let date = result.date
                let success = result.success
                
                var chat = self?.newChattingSet.first { chat in
                    chat.id == id
                }
                
                guard var chat else { return }
                
                guard var removed = self?.newChattingSet.remove(chat) else { return }
                
                removed.updateState(success, date)
                
                self?.newChattingSet.insert(removed)
                
                output.chatUpdated.send(0)
            }
            .store(in: &cancellables)
        
        self.listenOthersChattingsUseCase.newMessages
            .sink { [weak self] chats in
                chats.forEach { chat in
                    self?.newChattingSet.insert(chat)
                }

                output.newMessageArrived.send(chats.count)
            }
            .store(in: &cancellables)

        return output
    }
}
