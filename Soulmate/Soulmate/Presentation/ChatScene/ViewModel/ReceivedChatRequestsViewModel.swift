//
//  ReceivedChatRequestsViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import Combine

final class ReceivedChatRequestsViewModel {
    
    private weak var coordinator: ChatCoordinator?
    private let loadReceivedChatRequestsUseCase: LoadReceivedChatRequestsUseCase
    var requests: [ReceivedRequest] {
        return loadReceivedChatRequestsUseCase.requests.value
    }
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var requestsUpdated = PassthroughSubject<Void, Never>()
    }
    
    init(coordinator: ChatCoordinator, loadReceivedChatRequestsUseCase: LoadReceivedChatRequestsUseCase) {
        self.coordinator = coordinator
        self.loadReceivedChatRequestsUseCase = loadReceivedChatRequestsUseCase
    }
    
    func transform(input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.loadReceivedChatRequestsUseCase.listenRequests()
            }
            .store(in: &cancellables)
        
        self.loadReceivedChatRequestsUseCase.requests
            .sink { _ in
                output.requestsUpdated.send(())
            }
            .store(in: &cancellables)
        
        return output
    }
}
