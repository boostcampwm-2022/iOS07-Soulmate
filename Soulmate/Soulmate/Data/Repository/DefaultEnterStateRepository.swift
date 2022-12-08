//
//  DefaultEnterStateRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine
import FirebaseFirestore

final class DefaultEnterStateRepository: EnterStateRepository {
        
    private let networkDatabaseApi: NetworkDatabaseApi
    
    init(authRepository: AuthRepository, networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }

    func set(state: Bool, in chatRoomId: String, uid: String) {
        let path = "ChatRooms/\(chatRoomId)/EnterState"
        
        networkDatabaseApi.update(path: path, documentId: uid, with: ["state": state])
    }
    
    func listenOtherEnterStateDocRef(in chatRoomId: String, othersId: String) -> DocumentReference {
        let path = "ChatRooms/\(chatRoomId)/EnterState"
        
        let docRef = networkDatabaseApi.documentRef(path: path, documentId: othersId)
        
        return docRef
    }
}
