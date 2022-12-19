//
//  NetworkStorageApi.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation

protocol NetworkKeyValueStorageApi {
    func set(key: String, value: Data) async throws
    func get(key: String) async throws -> Data
    func remove(key: String) async throws
}
