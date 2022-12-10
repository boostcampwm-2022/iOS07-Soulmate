//
//  DefaultFetchMatePreviewUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/10.
//

import Foundation

final class DefaultFetchMatePreviewUseCase: FetchMatePreviewUseCase {
    
    private let info: ChatRoomInfo
    private let userPreviewRepository: UserPreviewRepository
    private let authRepository: AuthRepository
    
    init(
        info: ChatRoomInfo,
        userPreviewRepository: UserPreviewRepository,
        authRepository: AuthRepository) {
            self.info = info
            self.userPreviewRepository = userPreviewRepository
            self.authRepository = authRepository
    }
    
    func fetchMatePreview() async throws -> UserPreview? {
        guard let uid = try? authRepository.currentUid(),
              let mateId = info.userIds.first(where: { $0 != uid }) else { return nil }
        
        return try await userPreviewRepository.downloadPreview(userUid: mateId)
    }
}
