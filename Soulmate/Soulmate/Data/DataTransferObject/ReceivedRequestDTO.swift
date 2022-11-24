//
//  ReceivedRequestDTO.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import FirebaseFirestore

struct ReceivedRequestDTO: Decodable {
    var userId: String
    var mateName: String
    var mateImage: String?
    var date: Timestamp
    
    func toModel() -> ReceivedRequest {
        return ReceivedRequest(
            userId: userId,
            mateName: mateName,
            mateImage: mateImage,
            date: date.dateValue()
        )
    }
}
