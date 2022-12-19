//
//  DefaultLoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine

final class DefaultLoadChattingRoomListUseCase: LoadChattingRoomListUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    private let authRepository: AuthRepository
    
    var chattingRoomList: CurrentValueSubject<[ChatRoomInfo], Never>
    
    init(chatRoomRepository: ChatRoomRepository, authRepository: AuthRepository) {
        self.chatRoomRepository = chatRoomRepository
        self.authRepository = authRepository
        
        self.chattingRoomList = chatRoomRepository.chatRoomList
    }
    
    func loadChattingRooms() {
        guard let uid = try? authRepository.currentUid() else { return }
        
        chatRoomRepository.loadChatRooms(of: uid)
    }
}
