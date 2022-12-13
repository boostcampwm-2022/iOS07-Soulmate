//
//  DefaultUserHeartInfoRepository.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/07.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserHeartInfoRepository {
    func registerHeart(uid: String, heartInfo: UserHeartInfo) async throws
    func updateHeart(uid: String, heartInfo: UserHeartInfo) async throws
    func listenHeartUpdate(userId: String) -> DocumentReference
    func getHeart(uid: String) async throws -> UserHeartInfo
}

final class DefaultUserHeartInfoRepository: UserHeartInfoRepository {
    
    private let path = "UserHeartInfo"
    private let networkDatabaseApi: NetworkDatabaseApi
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func registerHeart(uid: String, heartInfo: UserHeartInfo) async throws {
        try await networkDatabaseApi.create(
            table: path,
            documentID: uid,
            data: heartInfo.toDTO()
        )
    }
    
    func updateHeart(uid: String, heartInfo: UserHeartInfo) async throws {
        guard let addingHeart = heartInfo.heart else { return }
        try await networkDatabaseApi.update(
            table: path,
            documentID: uid,
            with: ["heart": FieldValue.increment(Int64(addingHeart))]
        )
    }
    
    func listenHeartUpdate(userId: String) -> DocumentReference {
        return networkDatabaseApi.documentRef(path: path, documentId: userId)
    }
    
    func getHeart(uid: String) async throws -> UserHeartInfo {
        return try await networkDatabaseApi.read(
            table: path,
            documentID: uid,
            type: UserHeartInfoDTO.self
        ).toModel()
    }
}
