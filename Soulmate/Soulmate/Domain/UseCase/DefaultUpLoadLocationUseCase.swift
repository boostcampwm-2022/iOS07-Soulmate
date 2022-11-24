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
    
    init(userPreviewRepository: UserPreviewRepository) {
        self.userPreviewRepository = userPreviewRepository
    }
    
    func updateLocation(location: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await userPreviewRepository.updateLocation(userUid: uid, location: location)
    }
}
