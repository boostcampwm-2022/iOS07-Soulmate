//
//  DefaultLoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultLoadChattingRoomListUseCase: LoadChattingRoomListUseCase {
    
    private let uid = Auth.auth().currentUser?.uid
    
    var chattingRoomList = CurrentValueSubject<[ChatRoomInfo], Never>([])
    
    func loadChattingRooms() {
        guard let uid else { return }
        
        let db = Firestore.firestore()
        
        let _ = db
            .collection("ChatRooms")
            .whereField("userIds", arrayContains: uid)
            .addSnapshotListener { [weak self] snapshot, err in
                
                guard let snapshot, err == nil else { return }
                
                let chatRoomInfoDTOs = snapshot.documents.compactMap { doc in
                    
                    var dto = try? doc.data(as: ChatRoomInfoDTO.self)
                    dto?.documentId = doc.documentID
                    
                    return dto
                }
                
                let chatRoomInfos = chatRoomInfoDTOs.map { $0.toModel() }.sorted { l, r in
                    guard let lDate = l.lastChatDate, let rDate = r.lastChatDate else { return true }
                    
                    return lDate > rDate
                }
                
                self?.chattingRoomList.send(chatRoomInfos)
            }
    }
}
