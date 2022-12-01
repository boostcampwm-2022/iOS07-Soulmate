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
    
    func uploadChatImageData(photoData: Data) async throws -> String {
        let uid = Auth.auth().currentUser!.uid
        let key = "\(uid)_low_profile"
        try await profilePhotoRepository.uploadPicture(fileName: key, data: photoData)
        
        return key
    }
    
    func uploadPhotoData(photoData: [Data?]) async throws -> [String] {
        guard photoData.allSatisfy{ $0 != nil } == true else { return [] }
        let photoData = photoData.compactMap { $0 }
        
        let uid = Auth.auth().currentUser!.uid
        return try await withThrowingTaskGroup(of: [String].self) { [weak self] group throws in
            for i in 0..<photoData.count {
                let key = "\(uid)_profile\(i)"
                group.addTask { [weak self] in
                    try await self?.profilePhotoRepository.uploadPicture(fileName: key, data: photoData[i])
                    return [key]
                }
            }
            
            let keyList = try await group.reduce(into: [String]()) {$0 += $1}
            
            return keyList.sorted { $0 < $1 }
        }
        
    }
}
