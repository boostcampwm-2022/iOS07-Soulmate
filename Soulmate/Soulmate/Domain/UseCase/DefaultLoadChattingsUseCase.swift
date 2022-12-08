//
//  DefaultLoadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultLoadChattingsUseCase: LoadChattingsUseCase {
    
    private let info: ChatRoomInfo
    private let chattingRepository: ChattingRepository
    private let authRepository: AuthRepository        
    
    init(
        with info: ChatRoomInfo,
        chattingRepository: ChattingRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.chattingRepository = chattingRepository
            self.authRepository = authRepository
    }
    
    func loadChattings() async -> [Chat] {

        guard let chatRoomId = info.documentId, let uid = try? authRepository.currentUid() else { return [] }
        
        let dtos = await chattingRepository.loadReadChattings(from: chatRoomId)
        let infos = dtos.map { $0.toModel() }
        let chats = infos.map { info in
            let date = info.date
            let isMe = info.userId == uid
            let text = info.text
            
            return Chat(
                isMe: isMe,
                userId: info.userId,
                readUsers: info.readUsers,
                text: text,
                date: date,
                state: .validated
            )
        }
        
        return chats
    }
}
