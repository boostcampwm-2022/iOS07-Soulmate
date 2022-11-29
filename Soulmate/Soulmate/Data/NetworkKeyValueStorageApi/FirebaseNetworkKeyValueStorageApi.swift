//
//  File.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation
import FirebaseStorage

class FirebaseNetworkKeyValueStorageApi: NetworkKeyValueStorageApi {
    
    let storage = Storage.storage()
    
    func set(key: String, value: Data) async throws {
        try await storage.reference().child(key).putDataAsync(value)
    }
    
    func get(key: String) async throws -> Data {
        let url = try await storage.reference().child(key).downloadURL()
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return data
    }
    
    func remove(key: String) async throws {
        try await storage.reference().child(key).delete()
    }

}
