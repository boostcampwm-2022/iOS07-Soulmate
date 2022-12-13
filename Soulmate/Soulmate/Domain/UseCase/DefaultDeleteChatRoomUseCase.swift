//
//  DefaultDeleteChatRoomUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/13.
//

import Foundation

final class DefaultDeleteChatRooMUseCase: DeleteChatRoomUseCase {
    
    private let chatRoomRepository: ChatRoomRepository
    
    init(chatRoomRepository: ChatRoomRepository) {
        self.chatRoomRepository = chatRoomRepository
    }
    
    func execute(chatRoomInfo: ChatRoomInfo) async {
        try? await chatRoomRepository.deleteChatRoom(chatRoomInfo)
    }
}
