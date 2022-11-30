//
//  DefaultFetchImageUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/29.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultFetchImageUseCase: FetchImageUseCase {
    let profilePhotoRepository: ProfilePhotoRepository
    let imageCacheRepository: ImageCacheRepository
    
    init(
        profilePhotoRepository: ProfilePhotoRepository,
        imageCacheRepository: ImageCacheRepository
    ) {
        self.profilePhotoRepository = profilePhotoRepository
        self.imageCacheRepository = imageCacheRepository
    }
    
    func fetchImage(for key: String) async -> Data? {
        
        if let cached = imageCacheRepository.get(key: key) {
            
            return cached
        }
        
        guard let fetchedData = try? await profilePhotoRepository.downloadPicture(
            fileName: key) else { return nil }
        
        imageCacheRepository.set(key: key, value: fetchedData)
        
        return fetchedData
    }
}
