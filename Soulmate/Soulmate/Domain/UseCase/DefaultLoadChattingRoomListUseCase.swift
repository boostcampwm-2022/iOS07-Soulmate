//
//  DefaultLoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultLoadChattingRoomListUseCase: LoadChattingRoomListUseCase {
    
    var chattingRoomList = CurrentValueSubject<[ChatRoomInfo], Never>([])
    
    func loadChattingRooms() {
        let db = Firestore.firestore()
        
        let _ = db.collection("ChatRooms").order(by: "lastDate", descending: true).addSnapshotListener { [weak self] snapshot, err in
            
            guard let snapshot, err == nil else { return }
            
            let chatRoomInfoDTOs = snapshot.documents.compactMap { doc in
                var dto = try? doc.data(as: ChatRoomInfoDTO.self)
                dto?.documentId = doc.documentID

                return dto
            }
            
            let chatRoomInfos = chatRoomInfoDTOs.map { $0.toModel() }
            
            self?.chattingRoomList.send(chatRoomInfos)
        }
    }
}
