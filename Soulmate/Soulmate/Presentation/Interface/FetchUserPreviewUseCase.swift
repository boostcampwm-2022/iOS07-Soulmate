//
//  FetchUserPreviewUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/10.
//

import Foundation

protocol FetchMatePreviewUseCase {
    func fetchMatePreview() async throws -> UserPreview?
}
