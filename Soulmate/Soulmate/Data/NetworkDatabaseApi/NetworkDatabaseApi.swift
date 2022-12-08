//
//  StorageInterface.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import FirebaseFirestore

protocol NetworkDatabaseApi {
    func create<T: Codable>(table: String, documentID: String, data: T) async throws
    func create(path: String, data: [String: Any]) async throws -> Bool    
    func read<T: Decodable>(table: String, documentID: String, type: T.Type) async throws -> T
    func read<T: Codable>(table: String, constraints: [QueryEntity], type: T.Type) async throws -> [T]
    func read<T: Decodable>(path: String, constraints: [QueryEntity], type: T.Type) async throws -> (data: [T], snapshot: QuerySnapshot)
    func update(table: String, documentID: String, with fields: [AnyHashable: Any]) async throws
    func update(table: String, constraints: [QueryEntity], with fields: [AnyHashable: Any]) async throws
    func update(path: String, documentId: String, with fields: [AnyHashable: Any])
    func delete(table: String, constraints: [QueryEntity]) async throws
    func query(path: String, constraints: [QueryEntity]) -> Query
    func documentRef(path: String, documentId: String) -> DocumentReference
}
