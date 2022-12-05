//
//  DownLoadPreviewUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation

protocol DownLoadMyPreviewUseCase {
    func downloadPreview() async throws -> UserPreview
}
