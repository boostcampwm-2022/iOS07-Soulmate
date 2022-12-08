//
//  MessageToSendDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import FirebaseFirestore

struct MessageToSendDTO: Encodable {    
    var docId: String
    var text: String
    var userId: String
    var readUsers: [String]
    var date: Timestamp
    
    func toDict() -> [String: Any] {
        return [
            "docId": docId,
            "text": text,
            "userId": userId,
            "readUsers": readUsers,
            "date": date
        ]
    }
}
