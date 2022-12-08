//
//  FireStoreStorage.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreNetworkDatabaseApi: NetworkDatabaseApi {
    
    let db = Firestore.firestore()

    func create<T: Codable>(table: String, documentID: String, data: T) async throws {
        let collection = db.collection(table)
        let encoder = Firestore.Encoder()
        let fetchData = try encoder.encode(data)
        try await collection.document(documentID).setData(fetchData)
    }
    
    func create<T: Encodable>(table: String, data: T) async throws -> String {
        let collection = db.collection(table)
        let encoder = Firestore.Encoder()
        let encodedData = try encoder.encode(data)
        
        let docRef = collection.document()
        try await docRef.setData(encodedData)
        
        return docRef.documentID
    }
        
    func create(path: String, data: [String: Any]) async throws {
        try await db.collection(path).addDocument(data: data)
    }
    
    func create(path: String, documentId: String, data: [String: Any]) async throws {
        try await db.collection(path).document(documentId).setData(data)
    }
    
    func read<T: Decodable>(table: String, documentID: String, type: T.Type) async throws -> T {
        let snapshot = try await db.collection(table).document(documentID).getDocument()
        return try snapshot.data(as: T.self)
    }
    
    func read<T: Codable>(table: String, constraints: [QueryEntity], type: T.Type) async throws -> [T] {
        var query = db.collection(table) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.map {
            try $0.data(as: T.self)
        }
    }
    
    func read<T: Decodable>(path: String, constraints: [QueryEntity], type: T.Type) async throws -> (data: [T], snapshot: QuerySnapshot) {
        var query = db.collection(path) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        let data = try snapshot.documents.map { try $0.data(as: T.self) }
        
        return (data, snapshot)
    }
    
    func update(table: String, documentID: String, with fields: [AnyHashable: Any]) async throws {
        let snapshot = try await db.collection(table).document(documentID).getDocument()
        try await snapshot.reference.updateData(fields)
    }

    func update(table: String, constraints: [QueryEntity], with fields: [AnyHashable: Any]) async throws {
        var query = db.collection(table) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        try await withThrowingTaskGroup(of: Void.self) { group throws in
            for document in snapshot.documents {
                group.addTask {
                    try await document.reference.updateData(fields)
                }
            }
        }
    }
    
    func update(path: String, documentId: String, with fields: [AnyHashable: Any]) {
        db.collection(path).document(documentId).updateData(fields)
    }

    func delete(table: String, constraints: [QueryEntity]) async throws {
        var query = db.collection(table) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        let snapshot = try await query.getDocuments()
        try await withThrowingTaskGroup(of: Void.self) { group throws in
            for document in snapshot.documents {
                group.addTask {
                    try await document.reference.delete()
                }
            }
        }
    }
    
    func delete(path: String, documentId: String) async throws {
        var docRef = db.collection(path).document(documentId)
        
        try await docRef.delete()
    }
    
    func query(path: String, constraints: [QueryEntity]) -> Query {
        var query = db.collection(path) as Query
        
        constraints.forEach {
            query = query.merge(with: $0)
        }
        
        return query
    }
    
    func documentRef(path: String, documentId: String) -> DocumentReference {
        return db.collection(path).document(documentId)
    }
}
