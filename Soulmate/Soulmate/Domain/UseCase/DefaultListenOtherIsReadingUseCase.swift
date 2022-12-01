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
    private let uid = Auth.auth().currentUser?.uid
    private var listenerRegistration: ListenerRegistration?
    var otherRead = PassthroughSubject<String, Never>()
    
    init(with info: ChatRoomInfo) {
        
        self.info = info
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    func listenOtherIsReading() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId, let uid else { return }
        guard let userId = info.userIds.first(where: { $0 != uid }) else { return }
        
        let query = db
            .collection("ChatRooms")
            .document(chatRoomId)
            .collection("LastRead")
            .whereField("userId", isEqualTo: userId)
        
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
