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
    private let loadChattingRepository: LoadChattingsRepository
    
    var initLoadedchattings = CurrentValueSubject<[Chat], Never>([])
    
    init(
        with info: ChatRoomInfo,
        loadChattingRepository: LoadChattingsRepository) {
        
            self.info = info
            self.loadChattingRepository = loadChattingRepository
    }
    
    func loadChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId, let uid else { return }
        
        let _ = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .whereField("readUsers", arrayContains: "\(uid)")
            .order(by: "date")
            .limit(toLast: 100)
            .getDocuments { [weak self] snapshot, err in
                
                guard let snapshot, err == nil else { return }
                
                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }
                let chats = infos.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    return Chat(isMe: isMe, userId: info.userId, readUsers: info.readUsers, text: text, date: date, state: .validated)
                }
                
                guard let startDocument = snapshot.documents.first,
                      let lastDocument = snapshot.documents.last else {
                    
                    self?.initLoadedchattings.send([])
                    
                    return                    
                }
                
                self?.loadChattingRepository.setStartDocument(startDocument)
                self?.loadChattingRepository.setLastDocument(lastDocument)
                
                self?.initLoadedchattings.send(chats)
            }
    }
}
