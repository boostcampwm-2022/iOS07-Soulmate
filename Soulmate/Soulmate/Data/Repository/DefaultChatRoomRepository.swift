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
    private var listenResgistration: ListenerRegistration?
    
    var chatRoomList = CurrentValueSubject<[ChatRoomInfo], Never>([])
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func removeListen() {
        listenResgistration?.remove()
        listenResgistration = nil
    }
    
    func loadChatRooms(of uid: String) {

        let path = "ChatRooms"
        
        let constraints: [QueryEntity] = [
            .init(field: "userIds", value: uid, comparator: .arrayContains)
        ]
        
        let query = networkDatabaseApi.query(path: path, constraints: constraints)
        
        listenResgistration = query.addSnapshotListener { [weak self] snapshot, err in
            guard let snapshot, err == nil else { return }
            
            let dtos = snapshot.documents.compactMap{ doc in
                var dto = try? doc.data(as: ChatRoomInfoDTO.self)
                dto?.documentId = doc.documentID
                
                return dto
            }
            
            let chatRoomInfos = dtos.map { $0.toModel() }.sorted { l, r in
                guard let lDate = l.lastChatDate, let rDate = r.lastChatDate else { return true }
                
                return lDate > rDate
            }
            
            self?.chatRoomList.send(chatRoomInfos)
        }
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
