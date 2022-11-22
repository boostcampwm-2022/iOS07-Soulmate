//
//  DefaultUploadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseAuth

class DefaultUploadDetailInfoUseCase: UploadDetailInfoUseCase {
    
    let db = FireStoreDatabaseStorage()
    
    func uploadDetailInfo(registerUserInfo: RegisterUserInfo) async throws {
        try await db.create(table: "UserDetailInfo", documentID: Auth.auth().currentUser!.uid, data: registerUserInfo.toDTO())
    }

}

// 다음버튼이 눌릴때마다 업로드
