//
//  StorageInterface.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation

protocol DatabaseStorage {
    func create<T: Codable>(table: String, documentID: String, data: T) async throws
    func read<T: Codable>(table: String, constraints: [QueryEntity], type: T.Type) async throws -> [T]
    func update(table: String, constraints: [QueryEntity], with fields: [AnyHashable: Any]) async throws
    func delete(table: String, constraints: [QueryEntity]) async throws
}
