//
//  DefaultUserDefaultsRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation

class DefaultUserDefaultsRepository: UserDefaultsRepository {
    
    let localKeyValueStorage: LocalKeyValueStorage
    
    init(localKeyValueStorage: LocalKeyValueStorage) {
        self.localKeyValueStorage = localKeyValueStorage
    }
    
    func set(key: String, value: Any?) {
        localKeyValueStorage.set(key: key, value: value)
    }
    
    func get<T>(key: String) -> T? {
        return localKeyValueStorage.get(key: key)
    }
    
    func remove(key: String) {
        localKeyValueStorage.remove(key: key)
    }
}
