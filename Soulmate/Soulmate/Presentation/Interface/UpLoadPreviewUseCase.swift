//
//  UpLoadPreviewUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

protocol UploadPreviewUseCase {
    func uploadPreview(userPreview: UserPreview) async throws
}
