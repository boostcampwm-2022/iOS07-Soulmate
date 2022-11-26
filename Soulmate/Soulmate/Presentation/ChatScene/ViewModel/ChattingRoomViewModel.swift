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
    var chattings: [Chat] {
        return loadChattingsUseCase.prevChattings.value + loadChattingsUseCase.initLoadedchattings.value + loadChattingsUseCase.newChattings.value
    }
    
    init(
        sendMessageUseCase: SendMessageUseCase,
        loadChattingsUseCase: LoadChattingsUseCase
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.loadChattingsUseCase = loadChattingsUseCase        
    }
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
        var message: AnyPublisher<String?, Never>
        var sendButtonDidTap: AnyPublisher<Void, Never>
        var loadPrevChattings: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var sendButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var chattingInitLoaded = PassthroughSubject<Void, Never>()
        var prevChattingLoaded = PassthroughSubject<Int, Never>()
        var newChattingLoaded = PassthroughSubject<Int, Never>()
        var keyboardHeight = KeyboardMonitor().$keyboardHeight        
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
        
        input.sendButtonDidTap
            .sink { [weak self] _ in
                self?.sendMessageUseCase.sendMessage()
            }
            .store(in: &cancellables)
        
        input.loadPrevChattings            
            .sink { [weak self] _ in
                self?.loadChattingsUseCase.loadPrevChattings()
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.sendButtonEnabled
            .sink { isEnabled in
                output.sendButtonEnabled.send(isEnabled)
            }
            .store(in: &cancellables)
        
        self.loadChattingsUseCase.initLoadedchattings
            .sink { [weak self] _ in
                output.chattingInitLoaded.send(())
                self?.loadChattingsUseCase.listenNewChattings()
            }
            .store(in: &cancellables)
        
        self.loadChattingsUseCase.loadedPrevChattingCount
            .sink { count in
                
                output.prevChattingLoaded.send(count)
            }
            .store(in: &cancellables)
        
        self.loadChattingsUseCase.loadedNewChattingCount
            .sink { count in
                output.newChattingLoaded.send(count)
            }
            .store(in: &cancellables)

        return output
    }
}
