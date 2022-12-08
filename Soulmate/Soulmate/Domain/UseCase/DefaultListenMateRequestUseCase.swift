//
//  DefaultListenMateRequestUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/08.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultListenMateRequestUseCase: ListenMateRequestUseCase {
    
    private let mateRequestRepository: MateRequestRepository
    private let authRepository: AuthRepository
    private var listenerRegistration: ListenerRegistration?
    
    var mateRequestListSubject = CurrentValueSubject<[ReceivedMateRequest], Never>([])
    
    init(
        mateRequestRepository: MateRequestRepository,
        authRepository: AuthRepository
    ) {
        self.mateRequestRepository = mateRequestRepository
        self.authRepository = authRepository
    }
    
    func listenMateRequest() {
        guard let uid = try? authRepository.currentUid() else { return }
        let query = mateRequestRepository.listenOthersRequest(userId: uid)
        
        listenerRegistration = query.addSnapshotListener { [weak self] snapshot, err in
            guard let snapshot, err == nil else { return }
            let receivedRequestDTOList = snapshot.documents.compactMap { document in
                try? document.data(as: ReceivedMateRequestDTO.self)
            }
            let receivedRequestList = receivedRequestDTOList.map { $0.toDomain() }
            self?.mateRequestListSubject.send(receivedRequestList)
            print(receivedRequestList)
        }
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
}

protocol ListenMateRequestUseCase {
    var mateRequestListSubject: CurrentValueSubject<[ReceivedMateRequest], Never> { get }
    func listenMateRequest()
    func removeListen()
}
