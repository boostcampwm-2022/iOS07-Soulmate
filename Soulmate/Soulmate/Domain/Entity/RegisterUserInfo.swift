//
//  RegisterUserInfo.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation

struct RegisterUserInfo {
    var uid: String?
    var gender: GenderType?
    var nickName: String?
    var birthDay: Date?
    var height: Int?
    var mbti: Mbti?
    var smokingType: SmokingType?
    var drinkingType: DrinkingType?
    var aboutMe: String?
    var imageList: [String]?
}

extension RegisterUserInfo {
    func toDTO() -> RegisterUserInfoDTO {
        RegisterUserInfoDTO(
            uid: self.uid,
            gender: self.gender?.rawValue,
            nickName: self.nickName,
            birthDay: self.birthDay,
            height: self.height,
            mbti: self.mbti?.toString(),
            smokingType: smokingType?.rawValue,
            drinkingType: drinkingType?.rawValue,
            aboutMe: aboutMe,
            imageList: self.imageList
        )
    }
}
