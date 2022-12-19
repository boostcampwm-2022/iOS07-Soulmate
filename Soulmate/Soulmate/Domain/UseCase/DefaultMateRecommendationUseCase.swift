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

final class DefaultMateRecommendationUseCase: MateRecommendationUseCase {
    
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
        
        if previewList.count <= 2 {
            return previewList
        } else {
            let indexList = randomIndex(recommendCount: 2, endIndex: previewList.count - 1)
            var randPreviewList = [UserPreview]()
            indexList.forEach {
                randPreviewList.append(previewList[$0])
            }
            return randPreviewList
        }
    }
    
    private func randomIndex(recommendCount: Int, endIndex: Int) -> [Int] {
        let numbers = Array(0...endIndex)
        var result = Set<Int>()
        while result.count < recommendCount {
            result.insert(numbers.randomElement()!)
        }
        return Array(result)
    }
}
