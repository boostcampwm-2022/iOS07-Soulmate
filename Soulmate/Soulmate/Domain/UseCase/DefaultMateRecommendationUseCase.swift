//
//  DefaultMateRecommendationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestore

class DefaultMateRecommendationUseCase: MateRecommendationUseCase {
    
    let userPreviewRepository: UserPreviewRepository
    let userDefaultsRepository: UserDefaultsRepository
    
    init(
        userPreviewRepository: UserPreviewRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func fetchRecommendedMate() async throws -> [UserPreview] {
        return try await userPreviewRepository.fetchRecommendedPreviewList(userGender: GenderType.female)
    }
    
    func fetchDistanceFilteredRecommendedMate(distance: Double) async throws -> [UserPreview] {
        guard let latitude: Double = userDefaultsRepository.get(key: "latestLatitude"),
              let longitude: Double = userDefaultsRepository.get(key: "latestLongitude") else {
            throw UserDefaultsError.noSuchKeyMatchedValue
        }
        
        return try await userPreviewRepository.fetchDistanceFilteredRecommendedPreviewList(
            userGender: .female,
            userLocation: Location(
                latitude: latitude,
                longitude: longitude
            ),
            distance: distance
        )
    }
    
}
