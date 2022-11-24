//
//  DefaultUpLoadPreviewCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseAuth

class DefaultUploadPreviewUseCase: UploadPreviewUseCase {

    let userPreviewRepository: UserPreviewRepository
    
    init(userPreviewRepository: UserPreviewRepository) {
        self.userPreviewRepository = userPreviewRepository
    }
    
    func uploadPreview(userPreview: UserPreview) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await userPreviewRepository.uploadPreview(userUid: uid, userPreview: userPreview)
    }
}
