//
//  Chat.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Foundation

struct Chat: Identifiable {
    enum ChatState {
        case validated
        case sending
        case fail
    }
    
    var id: String = UUID().uuidString
    var isMe: Bool
    var userId: String
    var readUsers: [String]
    var text: String
    var date: Date?
    var state: ChatState
    
    mutating func updateState(_ success: Bool, _ date: Date?) {
        self.state = success ? .validated : .fail
        self.date = date
    }
}
