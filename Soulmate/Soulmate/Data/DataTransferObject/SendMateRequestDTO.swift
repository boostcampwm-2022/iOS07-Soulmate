//
//  SendMateRequestDTO.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import FirebaseFirestore

struct SendMateRequestDTO {
    var createdAt: Timestamp
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}

extension SendMateRequestDTO: Encodable {
    func toDict() -> [String: Any] {
        return [
            "createdAt": self.createdAt,
            "requestUserId": self.requestUserId,
            "mateName": self.mateName,
            "mateProfileImage": self.mateProfileImage,
            "receivedUserId": self.receivedUserId
        ]
    }
}
