//
//  UserPreview.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestore

struct UserPreview {
    var uid: String?
    var gender: GenderType?
    var name: String?
    var birth: Date?
    var imageKey: String?
    var location: Location?
}

extension UserPreview {
    func toDTO() -> UserPreviewDTO {
        return UserPreviewDTO(
            uid: self.uid,
            gender: self.gender?.rawValue,
            name: self.name,
            birth: self.birth,
            imageKey: self.imageKey,
            location: self.location?.toGeoPoint() ?? nil
        )
    }
}
