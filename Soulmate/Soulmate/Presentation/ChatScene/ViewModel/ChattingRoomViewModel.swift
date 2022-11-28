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
    private let loadPrevChattingsUseCase: LoadPrevChattingsUseCase
    var chattings: [Chat] {
        return loadPrevChattingsUseCase.prevChattings.value + loadChattingsUseCase.initLoadedchattings.value
    }
    
    init(
        sendMessageUseCase: SendMessageUseCase,
        loadChattingsUseCase: LoadChattingsUseCase,
        loadPrevChattingsUseCase: LoadPrevChattingsUseCase
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.loadChattingsUseCase = loadChattingsUseCase
        self.loadPrevChattingsUseCase = loadPrevChattingsUseCase
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
            .sink { _ in
                output.chattingInitLoaded.send(())
            }
            .store(in: &cancellables)
        
        self.loadPrevChattingsUseCase.loadedPrevChattingCount
            .sink { count in
                output.prevChattingLoaded.send(count)
            }
            .store(in: &cancellables)

        return output
    }
}
