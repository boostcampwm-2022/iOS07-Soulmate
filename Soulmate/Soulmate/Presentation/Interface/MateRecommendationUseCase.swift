//
//  MateRecommendationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

protocol MateRecommendationUseCase {
    func fetchRecommendedMate() async throws -> [UserPreview]
    func fetchDistanceFilteredRecommendedMate(distance: Double) async throws -> [UserPreview]
}

