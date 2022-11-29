//
//  NSCacheLocalKeyValueStorage.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/28.
//

import Foundation

class CacheableData {
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
}

class NSCacheImageCacheStorage: ImageCacheStorage {
    
    let cache = NSCache<NSString, CacheableData>()
    
    func set(key: String, value: CacheableData) {
        cache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> CacheableData? {
        return cache.object(forKey: key as NSString)
    }
    
    func remove(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
}
