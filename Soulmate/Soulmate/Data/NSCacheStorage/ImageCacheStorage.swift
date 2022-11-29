//
//  ImageCacheStorage.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/28.
//

import Foundation

protocol ImageCacheStorage {
    func set(key: String, value: CacheableData)
    func get(key: String) -> CacheableData?
    func remove(key: String)
}
