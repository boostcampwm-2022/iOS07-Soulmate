//
//  DefaultMateRquestRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/08.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultMateRquestRepository: MateRequestRepository {
    
    private let path = "ReceivedRequest"
    private let networkDatabaseApi: NetworkDatabaseApi
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func sendMateRequest(request: SendMateRequest) async throws {
        try await networkDatabaseApi.create(
            path: path,
            data: request.toDTO().toDict()
        )
    }
    
    func listenOthersRequest(userId: String) -> Query {
        var constraints = [
            QueryEntity(field: "receivedUserId", value: userId, comparator: .isEqualTo),
            QueryEntity(field: "createdAt", value: "", comparator: .order)
        ]
        
        let query = networkDatabaseApi.query(path: path, constraints: constraints)
        
        return query
    }
    
    func deleteMateRequest(requestId: String) async throws {
        try await networkDatabaseApi.delete(path: path, documentId: requestId)
    }
}

protocol MateRequestRepository {
    func sendMateRequest(request: SendMateRequest) async throws
    func listenOthersRequest(userId: String) -> Query
    func deleteMateRequest(requestId: String) async throws
}


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

struct ReceivedMateRequest {
    var documentId: String?
    var createdAt: Date
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}
