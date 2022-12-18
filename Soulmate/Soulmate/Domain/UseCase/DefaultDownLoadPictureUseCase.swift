//
//  DefaultDownloadPictureUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

final class DefaultDownLoadPictureUseCase: DownLoadPictureUseCase {
    let profilePhotoRepository: ProfilePhotoRepository
    let imageCacheRepository: ImageCacheRepository
    
    init(
        profilePhotoRepository: ProfilePhotoRepository,
        imageCacheRepository: ImageCacheRepository
    ) {
        self.profilePhotoRepository = profilePhotoRepository
        self.imageCacheRepository = imageCacheRepository
    }
    
    // TODO: keyList대로 정렬 구현하기
    func downloadPhotoData(keyList: [String]) async throws -> [Data] {
        
        return try await withThrowingTaskGroup(of: [(String, Data)].self, returning: [Data].self) { [weak self] group throws in
            for key in keyList {
                group.addTask { [weak self] in
                    var imageData: Data = Data()
                    if let cachedData = self?.imageCacheRepository.get(key: key) {
                        imageData = cachedData
                    }
                    else if let fetchedData = try await self?.profilePhotoRepository.downloadPicture(fileName: key) {
                        imageData = fetchedData
                        self?.imageCacheRepository.set(key: key, value: fetchedData)
                    }
                    
                    return  [(key, imageData)]
                }
            }
            
            let allPictures = try await group.reduce(into: [(String, Data)]()) {$0 += $1}
            
            return allPictures.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
        
    }
}
