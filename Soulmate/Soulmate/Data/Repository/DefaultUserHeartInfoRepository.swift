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
//        let prevHeartInfo = try? await networkDatabaseApi.read(
//            table: path,
//            documentID: uid,
//            type: UserHeartInfoDTO.self
//        ).toModel()
//
//        let prevHeart = prevHeartInfo?.heart
        guard let addingHeart = heartInfo.heart else { return }
//        let newHeartInfo = UserHeartInfo(heart: (prevHeart ?? 0) + addingHeart)
//        try await networkDatabaseApi.create(
//            table: path,
//            documentID: uid,
//            data: newHeartInfo.toDTO()
//        )
        try await networkDatabaseApi.update(table: path, documentID: uid, with: ["heart": FieldValue.increment(Int64(addingHeart))])
    }
    
    func listenHeartUpdate(userId: String) -> DocumentReference {
        return networkDatabaseApi.documentRef(path: path, documentId: userId)
    }
    

}
