//
//  DefaultListenOtherIsReadingUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/30.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultListenOtherIsReadingUseCase: ListenOtherIsReadingUseCase {
    
    private let info: ChatRoomInfo
    private let chattingRepository: ChattingRepository
    private let authRepository: AuthRepository
    private var listenerRegistration: ListenerRegistration?    
    
    var otherRead = PassthroughSubject<String, Never>()
    
    init(
        with info: ChatRoomInfo,
        chattingRepository: ChattingRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.chattingRepository = chattingRepository
            self.authRepository = authRepository
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    func listenOtherIsReading() {
        
        guard let chatRoomId = info.documentId,
              let uid = try? authRepository.currentUid(),
              let userId = info.userIds.first(where: { $0 != uid }) else { return }
        
        let query = chattingRepository.listenOtherIsReading(
            from: chatRoomId,
            userId: userId
        )
        
        listenerRegistration = query.addSnapshotListener { [weak self] snapshot, err in
            guard let snapshot, err == nil else { return }
            
            snapshot.documentChanges.forEach { change in
                if change.type == .modified {
                    self?.otherRead.send(userId)
                }
            }
        }
    }
}
