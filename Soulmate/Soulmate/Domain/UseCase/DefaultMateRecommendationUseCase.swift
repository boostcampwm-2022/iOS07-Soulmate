//
//  DefaultMateRecommendationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class DefaultMateRecommendationUseCase: MateRecommendationUseCase {
    
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

    func fetchDistanceFilteredRecommendedMate(from userLocation: Location, distance: Double) async throws -> [UserPreview] {
        let uid = try authRepository.currentUid()
        
        let myGender = try await userPreviewRepository.downloadPreview(userUid: uid).gender!
        var previewList = try await userPreviewRepository.fetchDistanceFilteredRecommendedPreviewList(
            userUid: uid,
            userGender: myGender,
            userLocation: userLocation,
            distance: distance
        )
//        previewList.sort { Location.distance(from: userLocation, to: $0.location) ?? 0 <= $1.location?.toDistance(from: from) ?? 0 }
        return previewList
    }
}
