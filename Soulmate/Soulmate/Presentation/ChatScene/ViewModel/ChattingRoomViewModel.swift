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
    private var newChattings: [Chat] = []
    var chattings: [Chat] {
        return loadPrevChattingsUseCase.prevChattings.value
        + loadChattingsUseCase.initLoadedchattings.value
        + loadUnreadChattingsUseCase.unreadChattings.value
        + newChattings
    }
    
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
        var message: AnyPublisher<String?, Never>
        var messageSendEvent: AnyPublisher<Void, Never>?
        var loadPrevChattings: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var sendButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var chattingInitLoaded = PassthroughSubject<Void, Never>()
        var unreadChattingLoaded = PassthroughSubject<Void, Never>()
        var prevChattingLoaded = PassthroughSubject<Int, Never>()
        var chatUpdated = PassthroughSubject<Int, Never>()
        var newMessageArrived = PassthroughSubject<Void, Never>()
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
        
        input.message
            .compactMap { $0 }
            .sink { [weak self] text in                
                self?.sendMessageUseCase.updateMessage(text)
            }
            .store(in: &cancellables)
        
        input.messageSendEvent?
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
            .sink { [weak self] _ in
                output.chattingInitLoaded.send(())
                self?.loadUnreadChattingsUseCase.loadUnreadChattings()
                
            }
            .store(in: &cancellables)
        
        self.loadUnreadChattingsUseCase.unreadChattings
            .sink { [weak self] _ in
                output.unreadChattingLoaded.send(())
                self?.listenOthersChattingsUseCase.listenOthersChattings()
                self?.listenOtherIsReadingUseCase.listenOtherIsReading()
            }
            .store(in: &cancellables)
        
        self.loadPrevChattingsUseCase.loadedPrevChattingCount
            .sink { count in
                output.prevChattingLoaded.send(count)
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.newMessage
            .sink { [weak self] chat in
                self?.newChattings.append(chat)
                output.newMessageArrived.send(())
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.messageSended
            .sink { [weak self] result in
                let id = result.id
                let date = result.date
                let success = result.success
                
                if let index = self?.newChattings.firstIndex(
                    where: { chat in
                    chat.id == id
                    }) {
                    
                    self?.newChattings[index].updateState(success, date)
                    
                    if let row = self?.chattings.firstIndex(
                        where: { chat in
                        chat.id == id
                    }) {
                        
                        output.chatUpdated.send(row)
                    }
                }
            }
            .store(in: &cancellables)
        
        self.listenOthersChattingsUseCase.newMessages
            .sink { [weak self] chats in
                
                chats.forEach { newChat in
                    guard var index = self?.newChattings.count else { return }
                    
                    for chat in self?.newChattings.reversed() ?? [] {
                        
                        guard let date = chat.date, let newDate = newChat.date else { return }
                        
                        if date > newDate {
                            index -= 1
                        } else {
                            break
                        }
                    }
                    
                    if index == self?.newChattings.count {
                        if let endIndex = self?.newChattings.endIndex {
                            self?.newChattings.insert(newChat, at: endIndex)
                        }
                        
                    } else if 0..<(self?.newChattings.count ?? 0) ~= index {
                        self?.newChattings.insert(newChat, at: index)
                        
                    }
                    
                    print(index)
                    print(self?.newChattings)
                }
                
                output.newMessageArrived.send(())
            }
            .store(in: &cancellables)

        return output
    }
}
