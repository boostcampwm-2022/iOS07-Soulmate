//
//  DefaultLoadPictureUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseAuth

class DefaultUpLoadPictureUseCase: UploadPictureUseCase {

    let profilePhotoRepository: ProfilePhotoRepository
    
    init(profilePhotoRepository: ProfilePhotoRepository) {
        self.profilePhotoRepository = profilePhotoRepository
    }
    
    func uploadPhotoData(photoData: [Data?]) async throws -> [String]? {
        guard photoData.allSatisfy{ $0 != nil } == true else { return nil }
        let photoData = photoData.compactMap { $0 }
        
        let uid = Auth.auth().currentUser!.uid
        return try await withThrowingTaskGroup(of:[String].self) { [weak self] group throws in
            for i in 0..<photoData.count {
                let key = "\(uid)_profile\(i)"
                group.addTask { [weak self] in
                    try await self?.profilePhotoRepository.uploadPicture(fileName: key, data: photoData[i])
                    return [key]
                }
            }
            
            var keyList = [String]()
            return try await group.reduce(into: keyList) { $0 += $1 }
        }
        
    }
}
