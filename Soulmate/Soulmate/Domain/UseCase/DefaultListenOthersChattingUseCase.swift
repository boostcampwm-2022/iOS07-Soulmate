//
//  DefaultListenOthersChattingUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultListenOthersChattingUseCase: ListenOthersChattingUseCase {
    
    private let info: ChatRoomInfo
    private let uid = Auth.auth().currentUser?.uid
    private let loadChattingRepository: LoadChattingsRepository
    private var listenerRegistration: ListenerRegistration?
    var newMessages = PassthroughSubject<[Chat], Never>()
    
    init(
        with info: ChatRoomInfo,
        loadChattingRepository: LoadChattingsRepository) {
        
            self.info = info
            self.loadChattingRepository = loadChattingRepository
    }
    
    func listenOthersChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId,
              let lastDocument = loadChattingRepository.lastDocument, let uid else {
            return
        }

        listenerRegistration = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")            
            .order(by: "date")
            .start(afterDocument: lastDocument)            
            .addSnapshotListener { [weak self] snapshot, err in
                
                guard let snapshot, err == nil else { return }
                
                let messageInfoDTOs = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = messageInfoDTOs.map { return $0.toModel() }.reversed()
                let others = infos.filter { $0.userId != uid }
                let chats = others.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    return Chat(isMe: isMe, text: text, date: date, state: .validated)
                }
                
                
                guard !chats.isEmpty else { return }
                guard let lastDocument = snapshot.documents.last else { return }
                
                self?.loadChattingRepository.setLastDocument(lastDocument)
                self?.newMessages.send(chats)
                self?.listenerRegistration?.remove()
                self?.listenerRegistration = nil
                self?.listenOthersChattings()
            }
    }
}
