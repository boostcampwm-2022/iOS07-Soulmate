//
//  UserHeartInfoDTO.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/08.
//

import Foundation
import FirebaseFirestoreSwift

struct UserHeartInfoDTO: Codable {
    @DocumentID var uid: String?
    var heart: Int?
}

extension UserHeartInfoDTO {
    
    func toModel() -> UserHeartInfo {
        return UserHeartInfo(
            uid: self.uid,
            heart: self.heart
        )
    }
    
}
