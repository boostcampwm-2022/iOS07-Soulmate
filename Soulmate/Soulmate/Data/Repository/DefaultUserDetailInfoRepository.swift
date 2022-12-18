//
//  DefaultUserDetailInfoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation

final class DefaultUserDetailInfoRepository: UserDetailInfoRepository {
    
    let collectionTitle = "UserDetailInfo"
    
    let networkDatabaseApi: NetworkDatabaseApi
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func uploadDetailInfo(userUid: String, registerUserInfo: UserDetailInfo) async throws {
        try await networkDatabaseApi.create(table: collectionTitle, documentID: userUid, data: registerUserInfo.toDTO())
    }
    
    func downloadDetailInfo(userUid: String) async throws -> UserDetailInfo {
        return try await networkDatabaseApi.read(
            table: collectionTitle,
            documentID: userUid,
            type: UserDetailInfoDTO.self
        )
        .toDomain()
    }
    
}
