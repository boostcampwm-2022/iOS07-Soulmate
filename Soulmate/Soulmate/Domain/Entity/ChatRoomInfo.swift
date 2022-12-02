//
//  ChatRoomInfo.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Foundation

struct ChatRoomInfo {
    var documentId: String?
    var mateName: String?
    var mateProfileImage: Data?
    var userIds: [String]
    var unreadCount: [String: Double]
    var latestChatContent: String?
    var lastChatDate: Date?
}
