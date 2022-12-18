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
