//
//  ChatRoomInfoDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatRoomInfoDTO: Codable {
    @DocumentID var documentId: String?
    var userNames: [String: String]
    var userProfileImages: [String: String]
    var lastMessage: String?
    var unreadCount: [String: Double]
    var userIds: [String]
    var lastDate: Timestamp?
    
    func toModel() -> ChatRoomInfo {
        ChatRoomInfo(
            documentId: documentId,
            userNames: userNames,
            userProfileImages: userProfileImages,        
            userIds: userIds,
            unreadCount: unreadCount,
            latestChatContent: lastMessage,
            lastChatDate: lastDate?.dateValue()
        )
    }
}
