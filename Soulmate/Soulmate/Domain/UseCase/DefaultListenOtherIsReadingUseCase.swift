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
    
    init(with info: ChatRoomInfo) {
        
        self.info = info
    }
    
    func listenOtherIsReading() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId, let uid else { return }
        guard let userId = info.userIds.first(where: { $0 != uid }) else { return }
        
        let docRef = db
            .collection("ChatRooms")
            .document(chatRoomId)
            .collection("LastRead")
            .whereField("userId", isEqualTo: userId)
        
        docRef.addSnapshotListener { snapshot, err in
            guard let snapshot, err == nil else { return }
            
            
        }
    }
}
