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
    private let uid = Auth.auth().currentUser?.uid
    var chattings = CurrentValueSubject<[Chat], Never>([])
    
    init(with info: ChatRoomInfo) {
        self.info = info
    }
    
    func listenChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId else { return }
        
        let _ = db.collection("ChatRooms").document(chatRoomId).collection("Messages").order(by: "date", descending: true).addSnapshotListener { [weak self] snapshot, err in
            
            guard let snapshot, err == nil, let uid = self?.uid else { return }
            
            let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
            let infos = messageInfoDTOs.map { return $0.toModel() }.reversed()
            let chats = infos.map { info in
                let isMe = info.userId == uid
                let text = info.text
                
                return Chat(isMe: isMe, text: text)
            }

            self?.chattings.send(chats)
        }
    }
}
