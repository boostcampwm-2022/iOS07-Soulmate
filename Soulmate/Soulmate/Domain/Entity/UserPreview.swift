//
//  UserPreview.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import FirebaseFirestore

struct UserPreview: Hashable {
    var id = UUID().uuidString
    var uid: String?
    var gender: GenderType?
    var name: String?
    var birth: Date?
    var imageKey: String?
    var chatImageKey: String?
    var location: Location?
    var heart: Int?
}

extension UserPreview {
    func toDTO() -> UserPreviewDTO {
        return UserPreviewDTO(
            uid: self.uid,
            gender: self.gender?.rawValue,
            name: self.name,
            birth: self.birth,
            imageKey: self.imageKey,
            chatImageKey: self.chatImageKey,
            location: self.location?.toGeoPoint() ?? nil,
            heart: self.heart
        )
    }
    
    static func == (lhs: UserPreview, rhs: UserPreview) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
