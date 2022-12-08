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
    private var listenerRegistration: ListenerRegistration?
    
    var otherIsEntered = PassthroughSubject<String, Never>()    
    var othersEnterState = false
    
    init(
        with info: ChatRoomInfo,
        enterStateRepository: EnterStateRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.enterStateRepository = enterStateRepository
            self.authRepository = authRepository
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    func listenOthersEnterState() {
        guard let chatRoomId = info.documentId,
              let uid = try? authRepository.currentUid(),
              let othersId = info.userIds.first(where: { $0 != uid }) else { return }
        
        let docRef = enterStateRepository.listenOtherEnterStateDocRef(
            in: chatRoomId,
            othersId: othersId
        )
        
        listenerRegistration = docRef.addSnapshotListener { [weak self] snapshot, err in
            guard let document = snapshot, err == nil else { return }
            
            if let state = document.data()?["state"] as? Bool {
                self?.enterStateRepository.othersEnterState = state
                if state {
                    self?.otherIsEntered.send(othersId)
                }
            }
        }
    }
}
