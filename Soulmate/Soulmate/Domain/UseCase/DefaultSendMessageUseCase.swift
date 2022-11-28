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
    
    let db = Firestore.firestore()
    private let info: ChatRoomInfo
    private let uid = Auth.auth().currentUser?.uid
    private let userDocRef: DocumentReference
    
    init(with info: ChatRoomInfo) {
        self.info = info
        self.userDocRef = db.collection("UserDetailInfo").document("uid")
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
        guard let documentId = info.documentId, let uid = self.uid else { return }
        
        if let docRef = try? db.collection("ChatRooms").document(documentId).collection("Messages").addDocument(
            from: MessageToSendDTO(
                docId: documentId,
                text: messageToSend.value,
                userId: uid
            )
        ) {
            Task {
                do {
                    try await docRef.updateData(["date": FieldValue.serverTimestamp()])
                    let messageDoc = try await docRef.getDocument()                    
                    
                    guard let messageTime = messageDoc.data()?["date"] as? Timestamp else { return }
                    
                    try await db.collection("ChatRooms").document(documentId).updateData(
                        [
                            "lastMessage": messageToSend.value,
                            "lastDate": messageTime
                        ]
                    )
                    
                } catch {
                    print("Error update last data")
                }
            }
        } else {
            print("Error sending message document")
        }
    }
}
