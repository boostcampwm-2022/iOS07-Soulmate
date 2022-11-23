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
    
    init(userDetailInfoRepository: UserDetailInfoRepository) {
        self.userDetailInfoRepository = userDetailInfoRepository
    }
    
    func downloadDetailInfo(userUid: String) async throws -> RegisterUserInfo {
        guard let uid = Auth.auth().currentUser?.uid else { throw AuthError.noCurrentUserError}
        return try await userDetailInfoRepository.downloadDetailInfo(userUid: uid)
    }
}
