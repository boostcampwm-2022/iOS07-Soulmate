//
//  DefaultLoadUnreadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/29.
//


import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultLoadUnreadChattingsUseCase: LoadUnreadChattingsUseCase {
    
    private let info: ChatRoomInfo
    private let uid = Auth.auth().currentUser?.uid
    private let loadChattingRepository: LoadChattingsRepository
    
    var unreadChattings = CurrentValueSubject<[Chat], Never>([])
    
    init(
        with info: ChatRoomInfo,
        loadChattingRepository: LoadChattingsRepository) {
        
            self.info = info
            self.loadChattingRepository = loadChattingRepository
    }
    
    func loadUnreadChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId, let uid, let lastDocument = loadChattingRepository.lastDocument else { return }
        
        let _ = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")            
            .order(by: "date")
            .start(afterDocument: lastDocument)
            .getDocuments { [weak self] snapshot, err in
                
                guard let snapshot, err == nil else { return }
                
                snapshot.documents.forEach { doc in
                    
                    let docRef = db
                        .collection("ChatRooms")
                        .document(chatRoomId)
                        .collection("Messages")
                        .document(doc.documentID)
                    
                    let readUsers = (doc.data()["readUsers"] as? [String] ?? []) + [uid]
                    
                    docRef.updateData(["readUsers": readUsers])
                }

                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }
                let chats = infos.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    return Chat(isMe: isMe, userId: info.userId, text: text, date: date, state: .validated)
                }
                
                guard let lastDocument = snapshot.documents.last else {
                    
                    self?.unreadChattings.send([])
                    
                    return
                }
                                
                self?.loadChattingRepository.setLastDocument(lastDocument)
                
                self?.unreadChattings.send(chats)
            }
    }
}
