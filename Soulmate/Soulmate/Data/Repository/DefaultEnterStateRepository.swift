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
    
    private var enterStateListenerRegistration: ListenerRegistration?
    
    init(authRepository: AuthRepository, networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    var othersEnterState: Bool = false
    var otherIsEntered = PassthroughSubject<String, Never>()
    
    func removeListen() {
        enterStateListenerRegistration?.remove()
        enterStateListenerRegistration = nil
    }

    func set(state: Bool, in chatRoomId: String, uid: String) {
        let path = "ChatRooms/\(chatRoomId)/EnterState"
        
        networkDatabaseApi.update(path: path, documentId: uid, with: ["state": state])
    }
    
    func listenOtherEnterState(in chatRoomId: String, othersId: String) {
        let path = "ChatRooms/\(chatRoomId)/EnterState"
        
        let docRef = networkDatabaseApi.documentRef(path: path, documentId: othersId)
        
        enterStateListenerRegistration = docRef.addSnapshotListener { [weak self] snapshot, err in
            guard let document = snapshot, err == nil else { return }
            
            if let state = document.data()?["state"] as? Bool {
                self?.othersEnterState = state
                if state {
                    self?.otherIsEntered.send(othersId)
                }
            }
        }
    }
}
