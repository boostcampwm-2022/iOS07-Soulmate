//
//  DefaultProfilePhotoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

final class DefaultProfilePhotoRepository: ProfilePhotoRepository {
    
    let networkKeyValueStorageApi: NetworkKeyValueStorageApi
    
    init(networkKeyValueStorageApi: NetworkKeyValueStorageApi) {
        self.networkKeyValueStorageApi = networkKeyValueStorageApi
    }
    
    func downloadPicture(fileName: String) async throws -> Data {
        return try await networkKeyValueStorageApi.get(key: fileName)
    }
    
    func uploadPicture(fileName: String, data: Data) async throws {
        try await networkKeyValueStorageApi.set(key: fileName, value: data)
    }
}
