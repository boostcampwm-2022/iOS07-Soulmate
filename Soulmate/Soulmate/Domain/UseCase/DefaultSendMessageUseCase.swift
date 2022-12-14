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
    private let enterStateRepository: EnterStateRepository
    private let fcmRepository: FCMRepository
    private let userPreviewRepository: UserPreviewRepository
    
    
    init(
        with info: ChatRoomInfo,
        chattingRepository: ChattingRepository,
        authRepository: AuthRepository,
        enterStateRepository: EnterStateRepository,
        fcmRepository: FCMRepository,
        userPreviewRepository: UserPreviewRepository) {
        
            self.info = info
            self.chattingRepository = chattingRepository
            self.authRepository = authRepository
            self.enterStateRepository = enterStateRepository
            self.fcmRepository = fcmRepository
            self.userPreviewRepository = userPreviewRepository
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
        var readUsers = [uid]
        if enterStateRepository.othersEnterState {
            readUsers.append(othersId)
        }
        
        let chat = Chat(isMe: true, userId: uid, readUsers: readUsers, text: messageToSend.value, date: date, state: .sending)
        
        myMessage.send(chat)
        updateMessage("")
                
        let success = await chattingRepository.addMessage(
            MessageToSendDTO(
                docId: chatRoomId,
                text: chat.text,
                userId: uid,
                readUsers: [uid],
                date: .init(date: date)
            ),
            to: chatRoomId
        )
        
        if success {
            var sendedChat = chat
            sendedChat.updateState(true, date)
            messageSended.send(sendedChat)
            
            if !enterStateRepository.othersEnterState {
                await chattingRepository.increaseUnreadCount(of: othersId, in: chatRoomId)
            }
            
            guard let name = try? await userPreviewRepository.downloadPreview(
                userUid: uid).name else { return }
            
            await fcmRepository.sendChattingFCM(
                to: othersId,
                title: name,
                message: chat.text
            )
        } else {
            var failedChat = chat
            failedChat.updateState(false, nil)
            messageSended.send(failedChat)
        }
    }
}
