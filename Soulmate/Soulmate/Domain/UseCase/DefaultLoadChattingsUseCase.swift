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
        
        guard let chatRoomId = info.documentId else { return }
        
        let _ = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .order(by: "date")
            .limit(toLast: 50)
            .getDocuments { [weak self] snapshot, err in
                
                guard let snapshot, err == nil, let uid = self?.uid else { return }
                
                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }
                let chats = infos.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    return Chat(isMe: isMe, text: text, date: date, state: .validated)
                }
                
                guard let startDocument = snapshot.documents.first,
                      let lastDocument = snapshot.documents.last else {
                    return                    
                }
                
                self?.loadChattingRepository.setStartDocument(startDocument)
                self?.loadChattingRepository.setLastDocument(lastDocument)
                
                self?.initLoadedchattings.send(chats)
            }
    }
}
