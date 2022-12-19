//
//  UserDefaultsLocalKeyValueStorage.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation
import Combine

final class UserDefaulsLocalKeyValueStorage: LocalKeyValueStorage {
    
    func set(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get<T>(key: String) -> T? {
        let value = UserDefaults.standard.object(forKey: key)
        return value as? T
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func valuePublisher<Value>(path: KeyPath<UserDefaults, Value>) -> AnyPublisher<Value, Never> {
        return UserDefaults.standard
            .publisher(for: path)
            .eraseToAnyPublisher()
    }
    
}
