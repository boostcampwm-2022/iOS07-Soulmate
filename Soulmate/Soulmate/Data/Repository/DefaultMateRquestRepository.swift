//
//  DefaultMateRquestRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/08.
//

import Foundation
import FirebaseFirestore

final class DefaultMateRquestRepository: MateRequestRepository {
    
    private let collectionTitle = "ReceivedRequest"
    private let networkDatabaseApi: NetworkDatabaseApi
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func sendMateRequest(request: SendMateRequest) async -> Bool {
        return await networkDatabaseApi.create(
            path: collectionTitle,
            data: request.toDTO().toDict()
        )
    }
    
    func listenOthersRequest(userId: String) -> Query {
        let path = "ReceivedRequest"
        var constraints = [
            QueryEntity(field: "receivedUserId", value: userId, comparator: .isEqualTo),
            QueryEntity(field: "createdAt", value: "", comparator: .order)
        ]
        
        let query = networkDatabaseApi.query(path: path, constraints: constraints)
        
        return query
    }
}

protocol MateRequestRepository {
    func sendMateRequest(request: SendMateRequest) async -> Bool
    func listenOthersRequest(userId: String) -> Query
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
    var createdAt: Timestamp
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}

extension ReceivedMateRequestDTO {
    func toDomain() -> ReceivedMateRequest {
        ReceivedMateRequest(
            createdAt: self.createdAt.dateValue(),
            requestUserId: self.requestUserId,
            mateName: self.mateName,
            mateProfileImage: self.mateProfileImage,
            receivedUserId: self.receivedUserId
        )
    }
}

struct ReceivedMateRequest {
    var createdAt: Date
    var requestUserId: String
    var mateName: String
    var mateProfileImage: String
    var receivedUserId: String
}
