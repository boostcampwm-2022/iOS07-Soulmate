//
//  DefaultUpLoadPreviewCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseAuth

class DefaultUploadMyPreviewUseCase: UploadMyPreviewUseCase {

    let userPreviewRepository: UserPreviewRepository
    let authRepository: AuthRepository
    
    init(
        userPreviewRepository: UserPreviewRepository,
        authRepository: AuthRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
        self.authRepository = authRepository
    }
    
    func uploadPreview(userPreview: UserPreview) async throws {
        let uid = try authRepository.currentUid()
        try await userPreviewRepository.uploadPreview(userUid: uid, userPreview: userPreview)
    }
}
