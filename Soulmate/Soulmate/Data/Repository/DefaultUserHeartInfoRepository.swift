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
    func updateHeart(uid: String, heartInfo: UserHeartInfo) async throws
    func listenHeartUpdate(userId: String) -> DocumentReference
}

final class DefaultUserHeartInfoRepository: UserHeartInfoRepository {
    
    private let path = "UserHeartInfo"
    private let networkDatabaseApi: NetworkDatabaseApi
    
    init(networkDatabaseApi: NetworkDatabaseApi) {
        self.networkDatabaseApi = networkDatabaseApi
    }
    
    func updateHeart(uid: String, heartInfo: UserHeartInfo) async throws {
        let prevHeartInfo = try await networkDatabaseApi.read(
            table: path,
            documentID: uid,
            type: UserHeartInfoDTO.self
        ).toModel()
        
        guard let addingHeart = heartInfo.heart,
              let prevHeart = prevHeartInfo.heart else { return }

        let newHeartInfo = UserHeartInfo(heart: prevHeart + addingHeart)
        
        try await networkDatabaseApi.create(
            table: path,
            documentID: uid,
            data: newHeartInfo.toDTO()
        )
    }
    
    func listenHeartUpdate(userId: String) -> DocumentReference {
        return networkDatabaseApi.documentRef(path: path, documentId: userId)
    }
    

}
