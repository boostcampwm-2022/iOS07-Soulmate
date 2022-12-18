//
//  ReceivedMateRequestDTO.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ReceivedMateRequestDTO: Decodable {
    @DocumentID var documentId: String?
    var createdAt: Timestamp
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}

extension ReceivedMateRequestDTO {
    func toDomain() -> ReceivedMateRequest {
        ReceivedMateRequest(
            documentId: self.documentId,
            createdAt: self.createdAt.dateValue(),
            requestUserId: self.requestUserId,
            mateName: self.mateName,
            mateProfileImage: self.mateProfileImage,
            receivedUserId: self.receivedUserId
        )
    }
}
