//
//  UpLoadPreviewUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

protocol UploadMyPreviewUseCase {
    func registerPreview(userPreview: UserPreview) async throws
    func updatePreview(userPreview: UserPreview) async throws
}
