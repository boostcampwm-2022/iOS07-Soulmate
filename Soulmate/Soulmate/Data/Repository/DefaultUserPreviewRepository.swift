//
//  DefaultUserPreviewRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestore

class DefaultUserPreviewRepository: UserPreviewRepository {

    let networkDatabaseApi: NetworkDatabaseApi
    let collectionTitle = "UserPreview"
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
//    func downloadFilteredUserPreviews() async throws -> [RegisterUserInfo] {
//        return try await networkDatabaseApi.read(table: collectionTitle, constraints: [QueryEntity(field: "gender", value: "여성", comparator: .isEqualTo)], type: RegisterUserInfoDTO.self)
//            .map {
//                $0.toDomain()
//            }
//    }
    
    func uploadPreview(userUid: String, userPreview: UserPreview) async throws {
        try await networkDatabaseApi.create(
            table: collectionTitle,
            documentID: userUid,
            data: userPreview.toDTO()
        )
    }
    
    func updateLocation(userUid: String, location: Location) async throws {
        try await networkDatabaseApi.update(
            table: collectionTitle,
            documentID: userUid,
            with: [
                "location": location.toGeoPoint()
            ]
        )
    }
}
