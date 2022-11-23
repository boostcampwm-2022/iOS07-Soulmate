//
//  ChattingRoomViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine

final class ChattingRoomViewModel {
    
    private let sendMessageUseCase: SendMessageUseCase
    private let loadChattingsUseCase: LoadChattingsUseCase
    var chattings: [Chat] {
        return loadChattingsUseCase.loadedChattings.value
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
    }
    
    struct Output {
        var sendButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var reloadTableView = PassthroughSubject<Bool, Never>()
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
                self?.loadChattingsUseCase.testLoad()
            }
            .store(in: &cancellables)
        
        self.sendMessageUseCase.sendButtonEnabled
            .sink { isEnabled in
                output.sendButtonEnabled.send(isEnabled)
            }
            .store(in: &cancellables)
        
        self.loadChattingsUseCase.loadedNewChattings
            .filter { $0 }
            .sink { _ in
                output.reloadTableView.send(true)
            }
            .store(in: &cancellables)
        
        return output
    }
}
