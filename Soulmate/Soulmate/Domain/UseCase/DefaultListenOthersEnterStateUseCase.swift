//
//  DefaultListenOthersEnterStateUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


final class DefaultListenOthersEnterStateUseCase: ListenOthersEnterStateUseCase {
    
    private let info: ChatRoomInfo
    private var enterStateRepository: EnterStateRepository
    private let authRepository: AuthRepository
    
    var otherIsEntered: PassthroughSubject<String, Never>
    
    init(
        with info: ChatRoomInfo,
        enterStateRepository: EnterStateRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.enterStateRepository = enterStateRepository
            self.authRepository = authRepository
            
            self.otherIsEntered = enterStateRepository.otherIsEntered
    }
    
    func removeListen() {
        enterStateRepository.removeListen()
    }
    
    func listenOthersEnterState() {
        guard let chatRoomId = info.documentId,
              let uid = try? authRepository.currentUid(),
              let othersId = info.userIds.first(where: { $0 != uid }) else { return }
        
        enterStateRepository.listenOtherEnterState(
            in: chatRoomId,
            othersId: othersId
        )
    }
}
