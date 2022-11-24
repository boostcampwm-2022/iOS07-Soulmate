//
//  UserPreviewDTO.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct UserPreviewDTO: Codable {
    @DocumentID var uid: String?
    var name: String?
    var birth: Date?
    var location: GeoPoint?
}

extension UserPreviewDTO {
    func toDomain() -> UserPreview {
        
        var locationInstance: Location? = nil
        if let location = self.location {
            locationInstance = Location(
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
        
        return UserPreview(
            uid: self.uid,
            name: self.name,
            birth: self.birth,
            location: locationInstance
        )
    }
}
