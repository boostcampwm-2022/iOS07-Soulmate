//
//  DefaultSendMessageUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultSendMessageUseCase: SendMessageUseCase {
    var messageToSend = CurrentValueSubject<String, Never>("")
    var sendButtonEnabled = CurrentValueSubject<Bool, Never>(false)
    
    private let info: ChatRoomInfo
    private let uid = Auth.auth().currentUser?.uid
    
    init(with info: ChatRoomInfo) {
        self.info = info
    }
    
    func updateMessage(_ text: String) {
        messageToSend.send(text)
        
        if !messageToSend.value.isEmpty {
            sendButtonEnabled.send(true)
        } else {
            sendButtonEnabled.send(false)
        }
    }
    
    func sendMessage() {
        let db = Firestore.firestore()
        
        guard let documentId = info.documentId, let uid = self.uid else { return }
        
        if let docRef = try? db.collection("ChatRooms").document(documentId).collection("Messages").addDocument(
            from: MessageToSendDTO(
                docId: documentId,
                text: messageToSend.value,
                userId: uid
            )
        ) {
            docRef.updateData(["date" : FieldValue.serverTimestamp()])
        } else {
            print("Error sending message document")
        }
    }
}
