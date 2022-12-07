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
    var myMessage = PassthroughSubject<Chat, Never>()
    var messageSended = PassthroughSubject<Chat, Never>()
        
    private let info: ChatRoomInfo
    private let chattingRepository: ChattingRepository
    private let authRepository: AuthRepository     
    
    init(
        with info: ChatRoomInfo,
        chattingRepository: ChattingRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.chattingRepository = chattingRepository
            self.authRepository = authRepository
    }
    
    func updateMessage(_ text: String) {
        messageToSend.send(text)
        
        if !messageToSend.value.isEmpty {
            sendButtonEnabled.send(true)
        } else {
            sendButtonEnabled.send(false)
        }
    }
    
    func sendMessage() async {
        guard let chatRoomId = info.documentId,
              let uid = try? authRepository.currentUid(),
              let othersId = info.userIds.first(where: { $0 != uid }) else { return }
        
        let date = Date.now
        
        let chat = Chat(isMe: true, userId: uid, readUsers: [uid], text: messageToSend.value, date: date, state: .sending)
        myMessage.send(chat)
        
        await chattingRepository.updateUnreadCountToZero(of: chatRoomId, othersId: othersId)
        await chattingRepository.addMessage(
            MessageToSendDTO(
                docId: chatRoomId,
                text: messageToSend.value,
                userId: uid,
                readUsers: [uid],
                date: .init(date: date)
            ),
            to: chatRoomId
        )
        
        var sendedChat = chat
        sendedChat.updateState(true, date)
        messageSended.send(sendedChat)
        
        
        var failedChat = chat
        failedChat.updateState(false, nil)
        messageSended.send(failedChat)
    }
}
