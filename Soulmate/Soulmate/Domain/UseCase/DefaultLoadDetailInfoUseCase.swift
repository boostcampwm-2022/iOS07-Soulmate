//
//  DefaultLoadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseAuth

class DefaultLoadDetailInfoUseCase: LoadDetailInfoUseCase {
    
    let db = FireStoreDatabaseStorage()
    
    func loadDetailInfo(userUid: String) async throws -> RegisterUserInfo {
        return try await db.read(
            table: "UserDetailInfo",
            documentID: userUid,
            type: RegisterUserInfoDTO.self
        )
        .toDomain()
    }
}
