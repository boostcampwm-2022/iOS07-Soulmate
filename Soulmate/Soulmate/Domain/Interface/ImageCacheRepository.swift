//
//  ImageCacheRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/28.
//

import Foundation

protocol ImageCacheRepository {
    func get(key: String) -> Data?
    func set(key: String, value: Data)
}
