//
//  Chat.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit
import Foundation

struct Chat: Identifiable, Hashable {
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
    
    var height: CGFloat {
        return NSString(string: text).boundingRect(
            with: CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 18)],
            context: nil
        ).height
    }
    
    mutating func updateState(_ success: Bool, _ date: Date?) {
        self.state = success ? .validated : .fail
        self.date = date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
