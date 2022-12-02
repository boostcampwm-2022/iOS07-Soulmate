//
//  ChatRoomInfoDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import FirebaseFirestore

struct ChatRoomInfoDTO: Decodable {
    var documentId: String?
    var mateName: String
    var lastMessage: String?
    var unreadCount: [String: Double]
    var userIds: [String]
    var lastDate: Timestamp?
    
    func toModel() -> ChatRoomInfo {
        ChatRoomInfo(
            documentId: documentId,
            mateName: mateName,
            mateProfileImage: nil,
            userIds: userIds,
            unreadCount: unreadCount,
            latestChatContent: lastMessage,
            lastChatDate: lastDate?.dateValue()
        )
    }
}
