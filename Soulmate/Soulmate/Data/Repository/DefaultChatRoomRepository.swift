//
//  DefaultChatRoomRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine
import FirebaseFirestore

final class DefaultChatRoomRepository: ChatRoomRepository {
    
    private let networkDatabaseApi: NetworkDatabaseApi    
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func createChatRoom(from info: ChatRoomInfo) async throws {
        let path = "ChatRooms"
        let dto = info.toDTO()
                
        let docId = try await networkDatabaseApi.create(table: path, data: dto)
        try await createEnterState(chatRoomId: docId, ids: info.userIds)
    }
    
    func deleteChatRoom(_ info: ChatRoomInfo) async throws {
        let path = "ChatRooms"
        guard let documentId = info.documentId else { return }
        
        try await networkDatabaseApi.delete(path: path, documentId: documentId)
    }
    
    func createEnterState(chatRoomId: String, ids: [String]) async throws {
        let path = "ChatRooms/\(chatRoomId)/EnterState"
        
        for id in ids {
            try await networkDatabaseApi.create(
                path: path,
                documentId: id,
                data: ["state": false]
            )
        }
    }        
}
