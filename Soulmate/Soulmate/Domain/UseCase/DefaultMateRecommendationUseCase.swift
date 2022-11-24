//
//  DefaultMateRecommendationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

class DefaultMateRecommendationUseCase {
    
    let userPreviewRepository: UserPreviewRepository
    
    init(userPreviewRepository: UserPreviewRepository) {
        self.userPreviewRepository = userPreviewRepository
    }
    
    func mateRecommendate() async throws -> [RegisterUserInfo] {
        // TODO: 구현 필요
        return [RegisterUserInfo]()
    }
}
