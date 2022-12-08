//
//  ChatRoomInfo.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Foundation

struct ChatRoomInfo {
    var documentId: String?
    var userNames: [String: String]
    var userProfileImages: [String: String]
    var userIds: [String]
    var unreadCount: [String: Double]
    var latestChatContent: String?
    var lastChatDate: Date?
    
    func toDTO() -> ChatRoomInfoDTO {
        return ChatRoomInfoDTO(
            userNames: self.userNames,
            userProfileImages: self.userProfileImages,
            unreadCount: self.unreadCount,
            userIds: self.userIds
        )
    }
}
