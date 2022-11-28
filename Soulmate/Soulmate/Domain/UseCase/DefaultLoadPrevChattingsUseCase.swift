//
//  DefaultLoadPrevChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


final class DefaultLoadPrevChattingsUseCase: LoadPrevChattingsUseCase {
    
    private let info: ChatRoomInfo
    private let uid = Auth.auth().currentUser?.uid
    private let loadChattingRepository: LoadChattingsRepository
    
    var prevChattings = CurrentValueSubject<[Chat], Never>([])
    var loadedPrevChattingCount = PassthroughSubject<Int, Never>()
    
    init(
        with info: ChatRoomInfo,
        loadChattingRepository: LoadChattingsRepository) {
            
            self.info = info
            self.loadChattingRepository = loadChattingRepository
    }
    
    func loadPrevChattings() {
        let db = Firestore.firestore()
        
        guard let chatRoomId = info.documentId,
              let startDocument = loadChattingRepository.startDocument else { return }
        
        let _ = db.collection("ChatRooms")
            .document(chatRoomId)
            .collection("Messages")
            .order(by: "date", descending: true)
            .start(afterDocument: startDocument)
            .limit(to: 100)
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
                
                guard let lastDocument = snapshot.documents.last else { return }
                
                self?.loadChattingRepository.setStartDocument(lastDocument)
                
                let oldChats = self?.prevChattings.value ?? []
                let newChats = chats + oldChats
                
                self?.prevChattings.send(newChats)
                self?.loadedPrevChattingCount.send(chats.count)
            }
    }
}
