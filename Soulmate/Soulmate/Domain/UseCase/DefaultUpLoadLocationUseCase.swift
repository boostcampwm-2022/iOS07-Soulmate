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
    
    init(
        userPreviewRepository: UserPreviewRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func updateLocation(location: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userDefaultsRepository.set(key: "latestLatitude", value: location.latitude)
        userDefaultsRepository.set(key: "latestLongitude", value: location.longitude)
        try await userPreviewRepository.updateLocation(userUid: uid, location: location)
    }
}
