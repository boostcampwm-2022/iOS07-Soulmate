//
//  ReceivedChatRequestsViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import Combine
import Foundation

final class ReceivedChatRequestsViewModel {
    
    private weak var coordinator: ChatCoordinator?    
    private let listenMateRequestUseCase: ListenMateRequestUseCase
    private let fetchImageUseCase: FetchImageUseCase
    private let acceptMateRequest: AcceptMateRequestUseCase
    var requests: [ReceivedMateRequest] {
        return listenMateRequestUseCase.mateRequestListSubject.value
    }
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
        var requestAccept: AnyPublisher<ReceivedMateRequest, Never>
        var requestDeny: AnyPublisher<String, Never>
    }
    
    struct Output {
        var requestsUpdated = PassthroughSubject<Void, Never>()
    }
    
    init(
        coordinator: ChatCoordinator,
        listenMateRequestUseCase: ListenMateRequestUseCase,
        fetchImageUseCase: FetchImageUseCase,
        acceptMateRequest: AcceptMateRequestUseCase
    ) {
        self.coordinator = coordinator
        self.listenMateRequestUseCase = listenMateRequestUseCase
        self.fetchImageUseCase = fetchImageUseCase
        self.acceptMateRequest = acceptMateRequest
    }
    
    func transform(input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.listenMateRequestUseCase.listenMateRequest()
            }
            .store(in: &cancellables)
        
        input.requestAccept
            .sink { request in
                Task {
                    try await self.acceptMateRequest.acceptMateRequest(request)
                }
            }
            .store(in: &cancellables)
        
        input.requestDeny
            .sink { docId in
                
            }
            .store(in: &cancellables)
        
        self.listenMateRequestUseCase.mateRequestListSubject
            .sink { _ in
                output.requestsUpdated.send(())
            }
            .store(in: &cancellables)
        
        return output
    }
    
    func fetchProfileImage(key: String) async -> Data? {
        return await fetchImageUseCase.fetchImage(for: key)
    }
}
