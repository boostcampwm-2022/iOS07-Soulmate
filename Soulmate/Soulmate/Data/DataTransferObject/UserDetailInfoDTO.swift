//
//  RegisterUserInfoDTO.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserDetailInfoDTO: Codable {
    @DocumentID var uid: String?
    var gender: String?
    var nickName: String?
    var birthDay: Date?
    var height: Int?
    var mbti: String?
    var smokingType: String?
    var drinkingType: String?
    var aboutMe: String?
    var imageList: [String]?
}

extension UserDetailInfoDTO {
    func toDomain() -> UserDetailInfo {
        
        var genderInstance: GenderType? = nil
        if let gender = self.gender {
            genderInstance = GenderType(rawValue: gender)
        }
        
        var smokingInstance: SmokingType? = nil
        if let smoking = self.smokingType {
            smokingInstance = SmokingType(rawValue: smoking)
        }
        
        var drinkingInstance: DrinkingType? = nil
        if let drinking = self.drinkingType {
            drinkingInstance = DrinkingType(rawValue: drinking)
        }
        
        return UserDetailInfo(
            uid: self.uid,
            gender: genderInstance,
            nickName: self.nickName,
            birthDay: self.birthDay,
            height: self.height,
            mbti: Mbti.toDomain(target: self.mbti ?? ""),
            smokingType: smokingInstance,
            drinkingType: drinkingInstance,
            aboutMe: self.aboutMe,
            imageList: self.imageList
        )
        
    }
}
