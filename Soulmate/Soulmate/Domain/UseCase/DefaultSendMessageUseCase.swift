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
    var messageSended = PassthroughSubject<Chat, Never>()
    
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
        guard let documentId = info.documentId, let uid = self.uid,
              let othersId = info.userIds.first(where: { $0 != uid }) else { return }
        let chat = Chat(isMe: true, userId: uid, readUsers: [uid], text: messageToSend.value, date: Date.now, state: .sending)
        newMessage.send(chat)
        Task { [weak self] in
            var unreadCount = try await db.collection("ChatRooms").document(documentId).getDocument().data(as: ChatRoomInfoDTO.self).unreadCount
            // FIXME: force unwrapping 수정하기
            unreadCount[othersId]! += 1
            try await db.collection("ChatRooms").document(documentId).updateData(["unreadCount": unreadCount])
            
            do {
                let docRef = try db
                    .collection("ChatRooms")
                    .document(documentId)
                    .collection("Messages")
                    .addDocument(
                        from: MessageToSendDTO(
                            docId: documentId,
                            text: messageToSend.value,
                            userId: uid,
                            readUsers: [uid],
                            date: .init(date: Date.now)
                        )
                    )
                let messageDoc = try await docRef.getDocument()
                guard let messageTime = messageDoc.data()?["date"] as? Timestamp else { return }
                try await db.collection("ChatRooms").document(documentId).updateData(
                    [
                        "lastMessage": messageToSend.value,
                        "lastDate": messageTime
                    ]
                )
                var sendedChat = chat
                sendedChat.updateState(true, messageTime.dateValue())
                self?.messageSended.send(sendedChat)
            }
            catch {
                var failedChat = chat
                failedChat.updateState(false, nil)
                self?.messageSended.send(failedChat)
            }
        }
    }
}
