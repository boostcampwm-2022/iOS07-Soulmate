//
//  LocalKeyValueStorage.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation

protocol LocalKeyValueStorage {
    func set(key: String, value: Any?)
    func get<T>(key: String) -> T?
    func remove(key: String)
}
