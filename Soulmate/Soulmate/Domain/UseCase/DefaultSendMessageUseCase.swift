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
    var newMessage = PassthroughSubject<Chat, Never>()
    var messageSended = PassthroughSubject<(id: String, date: Date?, success: Bool), Never>()
    
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
        
        let chat = Chat(isMe: true, userId: uid, text: messageToSend.value, date: nil, state: .sending)
        newMessage.send(chat)
        
        if let docRef = try? db
            .collection("ChatRooms")
            .document(documentId)
            .collection("Messages")
            .addDocument(
                from: MessageToSendDTO(
                    docId: documentId,
                    text: messageToSend.value,
                    userId: uid,
                    date: .init(date: Date.now)
                ),
                completion: { [weak self] err in
                    if err != nil {
                        self?.messageSended.send((id: chat.id, date: nil, success: false))
                    }
                }
            ) {
            
            Task {
                do {
                    // FIXME: - 서버에 올라간 시점에 다시 Date를 업데이트 하면, date로 order할 때 문제가 생김.
                    // try await docRef.updateData(["date": FieldValue.serverTimestamp()])
                    let messageDoc = try await docRef.getDocument()
                    
                    guard let messageTime = messageDoc.data()?["date"] as? Timestamp else { return }
                    
                    try await db.collection("ChatRooms").document(documentId).updateData(
                        [
                            "lastMessage": messageToSend.value,
                            "lastDate": messageTime
                        ]
                    )
                    
                    messageSended.send((id: chat.id, date: messageTime.dateValue(), success: true))
                    
                } catch {
                    print("Error update last data")
                }
            }
        }
    }
}
