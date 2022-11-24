//
//  DefaultLoadReceivedChatRequestsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultLoadReceivedChatRequestsUseCase: LoadReceivedChatRequestsUseCase {
    
    private let uid = Auth.auth().currentUser?.uid
    var requests = CurrentValueSubject<[ReceivedRequest], Never>([])
    
    func listenRequests() {
        
        let db = Firestore.firestore()
        
        guard let uid else { return }
        
        let _ = db.collection("UserDetailInfo").document(uid).collection("ReceivedRequests").order(by: "date").addSnapshotListener { [weak self] snapshot, err in
            
            guard let snapshot, err == nil else { return }
            
            let dtos = snapshot.documents.compactMap { try? $0.data(as: ReceivedRequestDTO.self) }
            let models = dtos.map { $0.toModel() }
            
            self?.requests.send(models)
        }
    }
}
