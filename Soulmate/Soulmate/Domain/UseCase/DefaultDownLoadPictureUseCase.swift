//
//  DefaultDownloadPictureUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

class DefaultDownLoadPictureUseCase {
    let profilePhotoRepository: ProfilePhotoRepository
    
    init(profilePhotoRepository: ProfilePhotoRepository) {
        self.profilePhotoRepository = profilePhotoRepository
    }
    
    // TODO: keyList대로 정렬 구현하기
    func downloadPhotoData(keyList: [String]) async throws -> [Data] {
        
        return try await withThrowingTaskGroup(of: [(String, Data)].self, returning: [Data].self) { [weak self] group throws in
            for key in keyList {
                group.addTask { [weak self] in
                    let imageData = try await self?.profilePhotoRepository.downloadPicture(fileName: key)
                    return  [(key, imageData ?? Data())]
                }
            }
            
            let allPictures = try await group.reduce(into: [(String, Data)]()) {$0 += $1}
            
            return allPictures.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
        
    }
}
