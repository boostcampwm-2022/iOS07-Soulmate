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
    var gender: String?
    var name: String?
    var birth: Date?
    var imageKey: String?
    var chatImageKey: String?
    var location: GeoPoint?
    var heart: Int?
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
        
        var genderInstance: GenderType? = nil
        if let gender = self.gender {
            genderInstance = GenderType(rawValue: gender)
        }
        
        return UserPreview(
            uid: self.uid,
            gender: genderInstance,
            name: self.name,
            birth: self.birth,
            imageKey: self.imageKey,
            chatImageKey: self.chatImageKey,
            location: locationInstance,
            heart: self.heart
        )
    }
}
