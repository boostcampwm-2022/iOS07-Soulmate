//
//  DefaultDownLoadPreviewUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation

class DefaultDownLoadMyPreviewUseCase: DownLoadMyPreviewUseCase {
        
    let userPreviewRepository: UserPreviewRepository
    let authRepository: AuthRepository
    
    init(
        userPreviewRepository: UserPreviewRepository,
        authRepository: AuthRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.authRepository = authRepository
    }
    
    func downloadPreview() async throws -> UserPreview {
        let uid = try authRepository.currentUid()
        return try await userPreviewRepository.downloadPreview(userUid: uid)
    }
}
