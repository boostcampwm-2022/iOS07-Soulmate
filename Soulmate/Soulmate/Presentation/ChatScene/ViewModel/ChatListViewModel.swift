//
//  ChatListViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine

final class ChatListViewModel {
    
    private let loadChattingRoomListUseCase: LoadChattingRoomListUseCase
    var chattingList: [ChatRoomInfo] {
        loadChattingRoomListUseCase.chattingRoomList.value
    }

    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var listLoaded = PassthroughSubject<Void, Never>()
    }
    
    init(loadChattingRoomListUseCase: LoadChattingRoomListUseCase) {
        self.loadChattingRoomListUseCase = loadChattingRoomListUseCase
    }
    
    func transform(input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.loadChattingRoomListUseCase.loadChattingRooms()
            }
            .store(in: &cancellables)
        
        self.loadChattingRoomListUseCase.chattingRoomList
            .sink { _ in
                output.listLoaded.send(())
            }
            .store(in: &cancellables)
        
        return output
    }
}
