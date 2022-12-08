//
//  ChatRoomListViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Foundation
import Combine

final class ChatRoomListViewModel {
    
    private weak var coordinator: ChatCoordinator?
    private let loadChattingRoomListUseCase: LoadChattingRoomListUseCase
    private let fetchImageUseCase: FetchImageUseCase
    private let authUseCase: AuthUseCase
    var chattingList: [ChatRoomInfo] {
        loadChattingRoomListUseCase.chattingRoomList.value
    }

    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
        var didSelectRowAt: AnyPublisher<Int, Never>
    }
    
    struct Output {
        var listLoaded = PassthroughSubject<Void, Never>()
    }
    
    init(
        coordinator: ChatCoordinator,
        loadChattingRoomListUseCase: LoadChattingRoomListUseCase,
        fetchImageUseCase: FetchImageUseCase,
        authUseCase: AuthUseCase) {
            self.coordinator = coordinator
            self.loadChattingRoomListUseCase = loadChattingRoomListUseCase
            self.fetchImageUseCase = fetchImageUseCase
            self.authUseCase = authUseCase
        }
    
    func transform(input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.loadChattingRoomListUseCase.loadChattingRooms()
            }
            .store(in: &cancellables)
        
        input.didSelectRowAt
            .sink { [weak self] index in
                if let info = self?.chattingList[index] {
                    self?.coordinator?.showChatRoom(with: info)
                }
            }
            .store(in: &cancellables)
        
        self.loadChattingRoomListUseCase.chattingRoomList
            .sink { _ in
                output.listLoaded.send(())
            }
            .store(in: &cancellables)
        
        return output
    }
    
    func fetchProfileImage(key: String) async -> Data? {
        return await fetchImageUseCase.fetchImage(for: key)
    }
    
    func userUid() -> String? {
        return authUseCase.userUid()
    }
}
