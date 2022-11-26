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
    var initLoadedchattings = CurrentValueSubject<[Chat], Never>([])
    var prevChattings = CurrentValueSubject<[Chat], Never>([])
    var loadedPrevChattingCount = PassthroughSubject<Int, Never>()
    var startDocument: QueryDocumentSnapshot?
    var lastDocument: QueryDocumentSnapshot?
    
    init(with info: ChatRoomInfo) {
        self.info = info
    }
    
    func loadChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId else { return }
        
        let _ = db.collection("ChatRooms").document(chatRoomId).collection("Messages").order(by: "date").limit(toLast: 30).getDocuments { [weak self] snapshot, err in
            
            guard let snapshot, err == nil, let uid = self?.uid else { return }
            
            let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
            let infos = messageInfoDTOs.map { return $0.toModel() }
            let chats = infos.map { info in
                let date = info.date
                let isMe = info.userId == uid
                let text = info.text
                
                return Chat(isMe: isMe, text: text, date: date)
            }
            
            self?.startDocument = snapshot.documents.first
            self?.lastDocument = snapshot.documents.last
            
            
            self?.initLoadedchattings.send(chats)
        }
    }
    
    func loadPrevChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId, let startDocument else { return }
        
        let _ = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .order(by: "date", descending: true)
            .start(afterDocument: startDocument)
            .limit(to: 10)
            .getDocuments { [weak self] snapshot, err in
            
                guard let snapshot, err == nil, let uid = self?.uid else { return }
                
                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }.reversed()
                let chats = infos.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    return Chat(isMe: isMe, text: text, date: date)
                }
                
                self?.startDocument = snapshot.documents.last
                
                let oldChats = self?.prevChattings.value ?? []
                let newChats = chats + oldChats
                
                self?.prevChattings.send(newChats)
                self?.loadedPrevChattingCount.send(chats.count)
            }
    }
}
