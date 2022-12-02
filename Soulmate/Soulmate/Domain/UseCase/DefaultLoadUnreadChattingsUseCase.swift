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
    
    var unreadChattings = PassthroughSubject<[Chat], Never>()
    
    init(
        with info: ChatRoomInfo,
        loadChattingRepository: LoadChattingsRepository) {
        
            self.info = info
            self.loadChattingRepository = loadChattingRepository
    }
    
    func loadUnreadChattings() {
        let db = Firestore.firestore()
                       
        guard let chatRoomId = info.documentId, let uid else { return }
        
        var query = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .order(by: "date")
        
        if let lastDocument = loadChattingRepository.lastDocument {
            query = query
                .start(afterDocument: lastDocument)
        }
        
        let _ = query
            .getDocuments { [weak self] snapshot, err in
                
                guard let snapshot, err == nil else { return }
                
                snapshot.documents.forEach { doc in
                    
                    let docRef = doc.reference
                    var readUsers = Set(doc.data()["readUsers"] as? [String] ?? [])
                    readUsers.insert(uid)
                    var arrReadUsers = readUsers.map { $0 }
                    
                    docRef.updateData(["readUsers": arrReadUsers])
                }
                
                let lastReadDocRef = db
                    .collection("ChatRooms")
                    .document(chatRoomId)
                    .collection("LastRead")
                    .document("\(uid)")
                
                lastReadDocRef.updateData(
                    ["lastReadTime" : Timestamp(date: Date.now)]
                )
                
                guard let othersId = self?.info.userIds.first(where: { $0 != uid }) else { return }
                
                db.collection("ChatRooms").document(chatRoomId).updateData(["unreadCount": [uid: 0.0, othersId: 0.0 ]])
                     

                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }
                let chats = infos.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    return Chat(isMe: isMe, userId: info.userId, readUsers: info.readUsers + [uid], text: text, date: date, state: .validated)
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
