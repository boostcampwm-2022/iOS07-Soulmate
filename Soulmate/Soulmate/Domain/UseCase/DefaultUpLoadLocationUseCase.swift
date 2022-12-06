//
//  DefaultUpLoadLocationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseAuth
import CoreLocation

protocol UpLoadLocationUseCase {
    func updateLocation(location: Location) async throws
}

class DefaultUpLoadLocationUseCase: UpLoadLocationUseCase {
    let userPreviewRepository: UserPreviewRepository
    let userDefaultsRepository: UserDefaultsRepository
    let authRepository: AuthRepository
    
    init(
        userPreviewRepository: UserPreviewRepository,
        userDefaultsRepository: UserDefaultsRepository,
        authRepository: AuthRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.authRepository = authRepository
    }
    
    func updateLocation(location: Location) async throws {
        let uid = try authRepository.currentUid()

        // FIXME: 바로 다음 디버깅시 지우자
        userDefaultsRepository.remove(key: "latestLatitude")
        userDefaultsRepository.remove(key: "latestLongitude")
        
        let encodedLocation = try JSONEncoder().encode(location)
        userDefaultsRepository.set(key: "latestLocation", value: encodedLocation)
        try await userPreviewRepository.updateLocation(userUid: uid, location: location)
    }
}
