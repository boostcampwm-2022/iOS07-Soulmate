//
//  DownLoadPreviewUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation

protocol DownLoadPreviewUseCase {
    func downloadPreview(userUid: String) async throws -> UserPreview
}
