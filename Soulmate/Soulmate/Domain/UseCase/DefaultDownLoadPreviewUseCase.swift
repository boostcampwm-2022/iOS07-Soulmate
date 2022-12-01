//
//  DefaultDownLoadPreviewUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation

class DefaultDownLoadPreviewUseCase: DownLoadPreviewUseCase {
        
    let userPreviewRepository: UserPreviewRepository
    
    init(userPreviewRepository: UserPreviewRepository) {
        self.userPreviewRepository = userPreviewRepository
    }
    
    func downloadPreview(userUid: String) async throws -> UserPreview {
        return try await userPreviewRepository.downloadPreview(userUid: userUid)
    }
}
