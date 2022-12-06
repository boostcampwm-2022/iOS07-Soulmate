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
    
    init(
        userPreviewRepository: UserPreviewRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func fetchRecommendedMate() async throws -> [UserPreview] {
        
        let myGender = try await userPreviewRepository.downloadPreview(userUid: Auth.auth().currentUser!.uid).gender!
        
        return try await userPreviewRepository.fetchRecommendedPreviewList(userGender: myGender)
    }
    
    func fetchDistanceFilteredRecommendedMate(distance: Double) async throws -> [UserPreview] {
        guard let latitude: Double = userDefaultsRepository.get(key: "latestLatitude"),
              let longitude: Double = userDefaultsRepository.get(key: "latestLongitude"),
              let uid = Auth.auth().currentUser?.uid else {
            throw UserDefaultsError.noSuchKeyMatchedValue
        }
        let preview = try await userPreviewRepository.downloadPreview(userUid: uid)
        let from = CLLocation(latitude: preview.location?.latitude ?? 0, longitude: preview.location?.longitude ?? 0)
        
        let myGender = try await userPreviewRepository.downloadPreview(userUid: uid).gender!
        
        var previewList = try await userPreviewRepository.fetchDistanceFilteredRecommendedPreviewList(
            userGender: myGender,
            userLocation: Location(
                latitude: latitude,
                longitude: longitude
            ),
            distance: distance
        )
        // 거리 가까운 순으로 정렬 preveiwList 정렬 후 반환
        previewList.sort { $0.location?.toDistance(from: from) ?? 0 <= $1.location?.toDistance(from: from) ?? 0 }
        return previewList
    }
    
}
