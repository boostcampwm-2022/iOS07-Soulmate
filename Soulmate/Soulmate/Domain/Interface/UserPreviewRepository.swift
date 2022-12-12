//
//  UserPrevInfoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

protocol UserPreviewRepository {
    func registerPreview(userUid: String, userPreview: UserPreview) async throws
    func updatePreview(userUid: String, userPreview: UserPreview) async throws
    func updateLocation(userUid: String, location: Location) async throws
    func fetchDistanceFilteredRecommendedPreviewList(userUid: String, userGender: GenderType, userLocation: Location, distance: Double) async throws -> [UserPreview]
    func fetchRecommendedPreviewList(userUid: String, userGender: GenderType) async throws -> [UserPreview]
    func downloadPreview(userUid: String) async throws -> UserPreview
}
