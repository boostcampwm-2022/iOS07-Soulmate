//
//  DefaultProfilePhotoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation
import FirebaseStorage

class DefaultProfilePhotoRepository: ProfilePhotoRepository {
    let storage = Storage.storage()
    
    func downloadPicture(fileName: String) async throws -> Data {
        let url = try await storage.reference().child(fileName).downloadURL()
        return try NSData(contentsOf: url) as Data
    }
    
    func uploadPicture(fileName: String, data: Data) async throws {
        try await storage.reference().child(fileName).putDataAsync(data)
    }
}
