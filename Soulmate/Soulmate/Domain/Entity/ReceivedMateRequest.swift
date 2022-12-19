//
//  ReceivedMateRequest.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation

struct ReceivedMateRequest {
    var documentId: String?
    var createdAt: Date
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}
