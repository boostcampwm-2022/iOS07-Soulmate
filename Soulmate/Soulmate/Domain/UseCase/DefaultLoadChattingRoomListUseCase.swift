//
//  DefaultLoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultLoadChattingRoomListUseCase: LoadChattingRoomListUseCase {
    
    var chattingRoomList = CurrentValueSubject<[ChatRoomInfo], Never>([])
    
    func loadChattingRooms() {
        let db = Firestore.firestore()
        
        let listener = db.collection("Users").document("A").collection("Messages").addSnapshotListener { [weak self] snapshot, _ in
            
            if let latesChatContents = snapshot?.documents.map({ $0["text"] }) {
                
                var newList: [ChatRoomInfo] = []
                
                latesChatContents.forEach { content in
                    if let chat = content as? String {
                        newList.append(ChatRoomInfo(mateName: "광고ㅋ", mateProfileImage: nil, latestChatContent: chat, lastChatDate: "오전 1:11"))
                    }
                }
                
                self?.chattingRoomList.send(newList)
            }
        }
    }
}
