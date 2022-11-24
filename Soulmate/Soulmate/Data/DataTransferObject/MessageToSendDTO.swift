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
}