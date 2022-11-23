//
//  DefaultUploadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseAuth

class DefaultUploadDetailInfoUseCase: UploadDetailInfoUseCase {
        
    let userDetailInfoRepository: UserDetailInfoRepository
    
    init(userDetailInfoRepository: UserDetailInfoRepository) {
        self.userDetailInfoRepository = userDetailInfoRepository
    }
    
    func uploadDetailInfo(registerUserInfo: RegisterUserInfo) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await userDetailInfoRepository.uploadDetailInfo(userUid: uid, registerUserInfo: registerUserInfo)
    }

}
