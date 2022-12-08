//
//  UserHeartInfo.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/08.
//

import Foundation

struct UserHeartInfo {
    var uid: String?
    var heart: Int?
}

extension UserHeartInfo {
    func toDTO() -> UserHeartInfoDTO {
        return UserHeartInfoDTO(

        )
    }
}
