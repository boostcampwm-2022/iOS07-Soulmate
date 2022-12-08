//
//  HeartShopUseCase.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/05.
//

import Foundation
import FirebaseAuth

protocol HeartUpdateUseCase {
    func chargeHeart(heart: Int) async throws
}

class DefaultHeartUpdateUseCase: HeartUpdateUseCase {
    
    let userHeartInfoRepository: UserHeartInfoRepository
    let authRepository: AuthRepository
    
    init(
        userHeartInfoRepository: UserHeartInfoRepository,
        authRepository: AuthRepository
    ) {
        self.userHeartInfoRepository = userHeartInfoRepository
        self.authRepository = authRepository
    }
    
    func chargeHeart(heart: Int) async throws {
        let uid = try authRepository.currentUid()
        try await userHeartInfoRepository.updateHeart(uid: uid, heartInfo: UserHeartInfo(heart: heart))
    }
}
