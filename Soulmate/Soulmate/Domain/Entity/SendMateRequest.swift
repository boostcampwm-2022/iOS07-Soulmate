//
//  SendMateRequest.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation

struct SendMateRequest {
    var createdAt: Date
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}

extension SendMateRequest {
    func toDTO() -> SendMateRequestDTO {
        SendMateRequestDTO(
            createdAt: .init(date: self.createdAt),
            requestUserId: self.requestUserId,
            mateName: self.mateName,
            mateProfileImage: self.mateProfileImage,
            receivedUserId: self.receivedUserId
        )
    }
}
