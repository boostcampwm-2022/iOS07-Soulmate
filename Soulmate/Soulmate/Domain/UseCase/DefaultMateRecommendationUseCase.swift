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
    
    func fetchRecommendedMate() async throws -> [UserPreview] {
        let uid = try authRepository.currentUid()
        let myGender = try await userPreviewRepository.downloadPreview(userUid: uid).gender!
        
        return try await userPreviewRepository.fetchRecommendedPreviewList(
            userUid: uid,
            userGender: myGender
        )
    }
    
    func fetchDistanceFilteredRecommendedMate(distance: Double) async throws -> [UserPreview] {
        guard let latitude: Double = userDefaultsRepository.get(key: "latestLatitude"),
              let longitude: Double = userDefaultsRepository.get(key: "latestLongitude") else {
            throw UserDefaultsError.noSuchKeyMatchedValue
        }
        let uid = try authRepository.currentUid()
        let preview = try await userPreviewRepository.downloadPreview(userUid: uid)
        let from = CLLocation(latitude: preview.location?.latitude ?? 0, longitude: preview.location?.longitude ?? 0)
        
        
        let myGender = try await userPreviewRepository.downloadPreview(userUid: uid).gender!
        var previewList = try await userPreviewRepository.fetchDistanceFilteredRecommendedPreviewList(
            userUid: uid,
            userGender: myGender,
            userLocation: Location(
                latitude: latitude,
                longitude: longitude
            ),
            distance: distance
        )
        previewList.sort { $0.location?.toDistance(from: from) ?? 0 <= $1.location?.toDistance(from: from) ?? 0 }
        return previewList
    }
}
