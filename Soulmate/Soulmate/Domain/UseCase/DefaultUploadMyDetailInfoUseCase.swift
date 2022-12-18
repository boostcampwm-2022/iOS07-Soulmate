//
//  DefaultUploadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseAuth

final class DefaultUploadMyDetailInfoUseCase: UploadMyDetailInfoUseCase {
        
    let userDetailInfoRepository: UserDetailInfoRepository
    let authRepository: AuthRepository
    
    init(
        userDetailInfoRepository: UserDetailInfoRepository,
        authRepository: AuthRepository
    ) {
        self.userDetailInfoRepository = userDetailInfoRepository
        self.authRepository = authRepository
    }
    
    func uploadDetailInfo(registerUserInfo: UserDetailInfo) async throws {
        try await userDetailInfoRepository.uploadDetailInfo(
            userUid: authRepository.currentUid(),
            registerUserInfo: registerUserInfo
        )
    }

}
