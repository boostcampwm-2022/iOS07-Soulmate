//
//  ChatRoomInfoDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import Foundation
import FirebaseFirestore

struct ChatRoomInfoDTO: Codable {
    var mateName: String
    var lastMessage: String
    var users: [String]
    var lastDate: Timestamp
    
    func toModel() -> ChatRoomInfo {
        ChatRoomInfo(
            mateName: mateName,
            mateProfileImage: nil,
            latestChatContent: lastMessage,
            lastChatDate: lastDate.dateValue()
        )
    }
}
