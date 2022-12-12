//
//  DefaultFetchMateChatImageKeyUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/10.
//

import Foundation

final class DefaultFetchMateChatImageKeyUseCase: FetchMateChatImageKeyUseCase {
    
    private let info: ChatRoomInfo
    private let authRepository: AuthRepository
    private let imageKeyUseCase: ImageKeyUseCase
    
    init(
        info: ChatRoomInfo,        
        authRepository: AuthRepository,
        imageKeyUseCase: ImageKeyUseCase) {
            self.info = info
            self.authRepository = authRepository
            self.imageKeyUseCase = imageKeyUseCase
    }
    
    func fetchMateChatImageKey() async -> String? {
        guard let uid = try? authRepository.currentUid(),
              let mateId = info.userIds.first(where: { $0 != uid }) else { return nil }
        
        return await imageKeyUseCase.imageKey(from: mateId)
    }
}
