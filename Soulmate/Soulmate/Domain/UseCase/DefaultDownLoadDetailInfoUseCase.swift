//
//  DefaultLoadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseAuth

class DefaultDownLoadDetailInfoUseCase: DownLoadDetailInfoUseCase {

    let userDetailInfoRepository: UserDetailInfoRepository
    let authRepository: AuthRepository
    
    init(
        userDetailInfoRepository: UserDetailInfoRepository,
        authRepository: AuthRepository
    ) {
        self.userDetailInfoRepository = userDetailInfoRepository
        self.authRepository = authRepository
    }
    
    func downloadMyDetailInfo() async throws -> RegisterUserInfo {
        let uid = try authRepository.currentUid()
        return try await userDetailInfoRepository.downloadDetailInfo(userUid: uid)
    }
    
    func downloadDetailInfo(userUid: String) async throws -> RegisterUserInfo {
        return try await userDetailInfoRepository.downloadDetailInfo(userUid: userUid)
    }
}
