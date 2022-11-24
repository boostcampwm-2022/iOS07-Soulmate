//
//  MessageInfoDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/23.
//

import FirebaseFirestore

struct MessageInfoDTO: Decodable {
    var docId: String
    var userId: String
    var text: String
    var date: Timestamp
    
    func toModel() -> MessageInfo {
        return MessageInfo(
            documentId: docId,
            userId: userId,
            text: text,
            date: date.dateValue()
        )
    }
}
