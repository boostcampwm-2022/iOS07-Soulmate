//
//  DefaultListenHeartUpdateUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/09.
//

import Foundation

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultListenHeartUpdateUseCase: ListenHeartUpdateUseCase {
    
    private let userHeartInfoRepository: UserHeartInfoRepository
    private let authRepository: AuthRepository
    private var listenerRegistration: ListenerRegistration?
    
    var heartInfoSubject = PassthroughSubject<UserHeartInfo, Never>()
    
    init(
        userHeartInfoRepository: UserHeartInfoRepository,
        authRepository: AuthRepository
    ) {
        self.userHeartInfoRepository = userHeartInfoRepository
        self.authRepository = authRepository
    }
    
    func listenHeartUpdate() {
        guard let uid = try? authRepository.currentUid() else { return }
        let docRef = userHeartInfoRepository.listenHeartUpdate(userId: uid)
        
        listenerRegistration = docRef.addSnapshotListener { [weak self] snapshot, err in
            guard let snapshot, err == nil else { return }
            
            guard let dto = try? snapshot.data(as: UserHeartInfoDTO.self) else { return }
            let userHeartInfo = dto.toModel()
            self?.heartInfoSubject.send(userHeartInfo)
        }
    }
    
    func removeListen() {
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
}

protocol ListenHeartUpdateUseCase {
    var heartInfoSubject: PassthroughSubject<UserHeartInfo, Never> { get }
    func listenHeartUpdate()
    func removeListen()
}
