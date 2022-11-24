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
    var name: String?
    var birth: Date?
    var location: Location?
}

extension UserPreview {
    func toDTO() -> UserPreviewDTO {
        return UserPreviewDTO(
            uid: self.uid,
            name: self.name,
            birth: self.birth,
            location: self.location?.toGeoPoint() ?? nil
        )
    }
}
