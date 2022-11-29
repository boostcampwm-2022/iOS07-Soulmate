//
//  DefaultImageCacheRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/28.
//

import UIKit

class DefaultImageCacheRepository: ImageCacheRepository {
    
    let imageCacheStorage: ImageCacheStorage
    
    init(imageCacheStorage: ImageCacheStorage) {
        self.imageCacheStorage = imageCacheStorage
    }
    
    func get(key: String) -> Data? {
        return imageCacheStorage.get(key: key)?.data
    }
    
    func set(key: String, value: Data) {
        imageCacheStorage.set(key: key, value: CacheableData(data: value))
    }
}
