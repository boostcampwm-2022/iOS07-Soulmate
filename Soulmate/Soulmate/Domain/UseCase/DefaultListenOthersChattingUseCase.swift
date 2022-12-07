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
    private let chattingRepository: ChattingRepository
    private let authRepository: AuthRepository
    private var listenerRegistration: ListenerRegistration?
    var othersMessages = PassthroughSubject<[Chat], Never>()
    
    init(
        with info: ChatRoomInfo,
        chattingRepository: ChattingRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.chattingRepository = chattingRepository
            self.authRepository = authRepository
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }

    func listenOthersChattings() {
        guard let chatRoomId = info.documentId, let uid = try? authRepository.currentUid() else { return }
        
        let query = chattingRepository.listenOthersChattingQuery(from: chatRoomId)
        
        // FIXME: - 메모리 관리 해줘야 함.
        listenerRegistration = query
            .addSnapshotListener { snapshot, err in
                guard let snapshot, err == nil, !snapshot.documentChanges.isEmpty else { return }
                
                let addChange = snapshot.documentChanges.filter { change in
                    change.type == .added
                }
                
                guard !addChange.isEmpty else { return }
                
                let dtos = snapshot.documents.compactMap { try? $0.data(as: MessageInfoDTO.self) }
                let infos = dtos.map { $0.toModel() }.reversed()
                let others = infos.filter { $0.userId != uid }
                let chats = others.map { info in
                    let date = info.date
                    let isMe = info.userId == uid
                    let text = info.text
                    
                    var readUsers = Set(info.readUsers)
                    readUsers.insert(uid)
                    var arrReadUsers = readUsers.map { $0 }
                    
                    return Chat(isMe: isMe, userId: info.userId, readUsers: arrReadUsers, text: text, date: date, state: .validated)
                }
                
                self.chattingRepository.addMeToReadUsers(of: snapshot)
                            
                // FIXME: - update 실패 시 처리 해줘야 함.
                Task {
                    self.othersMessages.send(chats)
                    await self.chattingRepository.updateLastRead(of: chatRoomId)
                    guard let othersId = self.info.userIds.first(where: { $0 != uid }) else { return }
                    await self.chattingRepository.updateUnreadCountToZero(of: chatRoomId, othersId: othersId)
                    self.chattingRepository.setLastDocument(snapshot.documents.last)                    
                    self.listenerRegistration?.remove()
                    self.listenerRegistration = nil
                    self.listenOthersChattings()
                }
            }
    }
}
