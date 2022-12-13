//
//  DefaultUpdateFCMTokenUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

final class DefaultUpdateFCMTokenUseCase: UpdateFCMTokenUseCase {
    
    private let authRepository: AuthRepository
    private let fcmRepository: FCMRepository
    
    init(
        authRepository: AuthRepository,
        fcmRepository: FCMRepository) {
        
            self.authRepository = authRepository
            self.fcmRepository = fcmRepository
    }
    
    func execute(token: String) async throws {
        if let uid = try? authRepository.currentUid() {
            try await fcmRepository.updateFCMToken(for: uid, token: token)
        }
        
    }
}
