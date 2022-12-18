//
//  DefaultUpLoadLocationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseAuth

class DefaultUpLoadLocationUseCase: UpLoadLocationUseCase {
    let userPreviewRepository: UserPreviewRepository
    let authRepository: AuthRepository
    
    init(
        userPreviewRepository: UserPreviewRepository,
        authRepository: AuthRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.authRepository = authRepository
    }
    
    func updateLocation(location: Location) async throws {
        let uid = try authRepository.currentUid()
        
        let encodedLocation = try JSONEncoder().encode(location)
        try await userPreviewRepository.updateLocation(userUid: uid, location: location)
    }
}
