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
    private let listenOthersEnterStateUseCase: ListenOthersEnterStateUseCase
    private let enterChatRoomUseCase: EnterChatRoomUseCase
    private let imageKeyUseCase: ImageKeyUseCase
    private let fetchImageUseCase: FetchImageUseCase
    private let fetchMatePreviewUseCase: FetchMatePreviewUseCase
    
    init(
        sendMessageUseCase: SendMessageUseCase,
        loadChattingsUseCase: LoadChattingsUseCase,
        loadUnreadChattingsUseCase: LoadUnreadChattingsUseCase,
        loadPrevChattingsUseCase: LoadPrevChattingsUseCase,
        listenOthersChattingsUseCase: ListenOthersChattingUseCase,
        listenOthersEnterStateUseCase: ListenOthersEnterStateUseCase,
        enterChatRoomUseCase: EnterChatRoomUseCase,
        imageKeyUseCase: ImageKeyUseCase,
        fetchImageUseCase: FetchImageUseCase,
        fetchMatePreviewUseCase: FetchMatePreviewUseCase
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.loadChattingsUseCase = loadChattingsUseCase
        self.loadUnreadChattingsUseCase = loadUnreadChattingsUseCase
        self.loadPrevChattingsUseCase = loadPrevChattingsUseCase
        self.listenOthersChattingsUseCase = listenOthersChattingsUseCase        
        self.listenOthersEnterStateUseCase = listenOthersEnterStateUseCase
        self.enterChatRoomUseCase = enterChatRoomUseCase
        self.imageKeyUseCase = imageKeyUseCase
        self.fetchImageUseCase = fetchImageUseCase
        self.fetchMatePreviewUseCase = fetchMatePreviewUseCase
    }
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
        var viewWillDisappear: AnyPublisher<Void, Never>
        var resignActive: AnyPublisher<Void, Never>
        var didBecomeActive: AnyPublisher<Void, Never>
        var message: AnyPublisher<String?, Never>
        var messageSendEvent: AnyPublisher<Void, Never>?
        var loadPrevChattings: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var sendButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var chattingInitLoaded = PassthroughSubject<[Chat], Never>()
        var unreadChattingLoaded = PassthroughSubject<[Chat], Never>()
        var prevChattingLoaded = PassthroughSubject<[Chat], Never>()
        var chatUpdated = PassthroughSubject<Chat, Never>()        
        var newMessageArrived = PassthroughSubject<[Chat], Never>()
        var keyboardHeight = KeyboardMonitor().$keyboardHeight
        var otherIsEntered = PassthroughSubject<String, Never>()
    }
    
    func fetchProfileImage(of uid: String) async -> Data? {
        guard let key = await imageKeyUseCase.imageKey(from: uid) else { return nil }
        guard let data = await fetchImageUseCase.fetchImage(for: key) else { return nil }
        
        return data
    }
    
    func mateName() async -> String? {
        return try? await fetchMatePreviewUseCase.fetchMatePreview()?.name
    }
    
    func transform(input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .sink { _ in
                Task {
                    let chats = await self.loadChattingsUseCase.loadChattings()
                    output.chattingInitLoaded.send(chats)                    
                    let unReadChats = await self.loadUnreadChattingsUseCase.loadUnreadChattings()
                    output.unreadChattingLoaded.send(unReadChats)
                    self.listenOthersChattingsUseCase.listenOthersChattings()
                    self.enterChatRoomUseCase.updateEnterState(true)
                    self.listenOthersEnterStateUseCase.listenOthersEnterState()
                }
            }
            .store(in: &cancellables)
        
        input.viewWillDisappear
            .sink { [weak self] _ in
                self?.enterChatRoomUseCase.updateEnterState(false)
                self?.listenOthersChattingsUseCase.removeListen()
                self?.listenOthersEnterStateUseCase.removeListen()                
            }
            .store(in: &cancellables)
        
        input.resignActive
            .sink { [weak self] _ in
                self?.enterChatRoomUseCase.updateEnterState(false)
            }
            .store(in: &cancellables)
        
        input.didBecomeActive
            .sink { [weak self] _ in
                self?.enterChatRoomUseCase.updateEnterState(true)
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
            .sink { _ in
                Task {
                    await self.sendMessageUseCase.sendMessage()
                }
            }
            .store(in: &cancellables)
        
        input.loadPrevChattings            
            .sink { _ in
                Task {
                    let chats = await self.loadPrevChattingsUseCase.loadPrevChattings()
                    output.prevChattingLoaded.send(chats)
                }
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.sendButtonEnabled
            .sink { isEnabled in
                output.sendButtonEnabled.send(isEnabled)
            }
            .store(in: &cancellables)

        self.sendMessageUseCase.myMessage
            .sink { chat in                
                output.newMessageArrived.send([chat])
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.messageSended
            .sink { chat in
                output.chatUpdated.send(chat)
            }
            .store(in: &cancellables)

        self.listenOthersChattingsUseCase.othersMessages
            .sink { chats in
                
                output.newMessageArrived.send(chats)
            }
            .store(in: &cancellables)
        
        self.listenOthersEnterStateUseCase.otherIsEntered
            .sink { othersId in
                output.otherIsEntered.send(othersId)
            }
            .store(in: &cancellables)

        return output
    }
}
