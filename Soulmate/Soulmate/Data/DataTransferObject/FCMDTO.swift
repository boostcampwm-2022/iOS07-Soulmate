//
//  FCMDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

struct FCMDTO<T: Codable>: Codable {
    private var notification: FCMNotification
    private var data: T
    private var to: String
    private var priority: String
    private var contentAvailable: Bool
    private var mutableContent: Bool
    
    init(title: String, body: String, data: T, to: String) {
        self.notification = FCMNotification(title: title, body: body)
        self.data = data
        self.to = to
        self.priority = "high"
        self.contentAvailable = true
        self.mutableContent = true
    }
    
    enum CodingKeys: String, CodingKey {
        case notification
        case data
        case to
        case priority
        case contentAvailable = "content_available"
        case mutableContent = "mutable_content"
    }
}
