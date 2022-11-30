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

struct ImageCache {
    private var cache = NSCache<NSString, CacheableData>()
    
    init() {
        self.cache.countLimit = 50
    }
    
    mutating func save(data: CacheableData, with key: String) {
        let key = NSString(string: key)
        
        self.cache.setObject(data, forKey: key)
    }
    
    func read(with key: String) -> CacheableData? {
        let key = NSString(string: key)
        
        return self.cache.object(forKey: key)
    }
    
    mutating func remove(with key: String) {
        let key = NSString(string: key)
        
        self.cache.removeObject(forKey: key)
    }
}

final class NSCacheImageCacheStorage: ImageCacheStorage {
    
    static let shared = NSCacheImageCacheStorage()
    
    private var cache = ImageCache()
    
    private init() { }
    
    func set(key: String, value: CacheableData) {
        cache.save(data: value, with: key)
    }

    func get(key: String) -> CacheableData? {
        return cache.read(with: key)
    }

    func remove(key: String) {
        cache.remove(with: key)
    }
    
}
