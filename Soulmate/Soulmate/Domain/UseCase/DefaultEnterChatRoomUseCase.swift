//
//  DefaultEnterChatRoomUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


final class DefaultEnterChatRoomUseCase: EnterChatRoomUseCase {
    private let info: ChatRoomInfo
    private let enterStateRepository: EnterStateRepository
    private let authRepository: AuthRepository
    
    init(
        with info: ChatRoomInfo,
        enterStateRepository: EnterStateRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.enterStateRepository = enterStateRepository
            self.authRepository = authRepository
    }
    
    
    func updateEnterState(_ state: Bool) {
        guard let uid = try?authRepository.currentUid(), let chatRoomId = info.documentId else { return }
        
        enterStateRepository.set(state: state, in: chatRoomId, uid: uid)
    }
}
