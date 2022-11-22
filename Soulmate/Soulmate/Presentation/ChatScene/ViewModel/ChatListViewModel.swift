//
//  ChatListViewModel.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine

final class ChatListViewModel {
    
    private let loadChattingRoomListUseCase: LoadChattingRoomListUseCase
    
    var chattingList: [ChattingRoomInfo] {
        return loadChattingRoomListUseCase.chattingRoomList.value
    }
    
    struct Input {
        var viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
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
        
        return output
    }
}
