//
//  RegisterUserInfo.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation

struct RegisterUserInfo {
    var id: String?
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
            id: self.id,
            gender: self.gender?.rawValue,
            nickName: self.nickName,
            birthDay: self.birthDay,
            height: self.height,
            mbti: self.mbti?.toString(),
            smokingType: smokingType?.rawValue,
            drinkingType: drinkingType?.rawValue,
            aboutMe: aboutMe
        )
    }
}

struct RegisterUserInfoDTO: Codable {
    var id: String?
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

extension RegisterUserInfoDTO {
    func toDomain() -> RegisterUserInfo {
        return RegisterUserInfo(
            id: self.id,
            gender: self.gender == nil ? nil : GenderType(rawValue: self.gender!),
            nickName: self.nickName,
            birthDay: self.birthDay,
            mbti: self.mbti == nil ? nil : Mbti.toDomain(target: self.mbti!),
            smokingType: self.smokingType == nil ? nil : SmokingType(rawValue: self.smokingType!),
            drinkingType: self.drinkingType == nil ? nil : DrinkingType(rawValue: self.drinkingType!),
            aboutMe: self.aboutMe,
            imageList: self.imageList
        )
    }
}

struct Mbti {
    var innerType: InnerType
    var recognizeType: RecognizeType
    var judgementType: JudgementType
    var lifeStyleType: LifeStyleType
}

enum InnerType: String {
    case i = "i"
    case e = "e"
}

enum RecognizeType: String {
    case n = "n"
    case s = "s"
}

enum JudgementType: String {
    case t = "t"
    case f = "f"
}

enum LifeStyleType: String {
    case p = "p"
    case j = "j"
}

extension Mbti {
    func toString() -> String{
        return "\(self.innerType.rawValue)\(self.recognizeType.rawValue)\(self.judgementType.rawValue)\(self.lifeStyleType.rawValue)"
    }
}

extension Mbti {
    static func toDomain(target: String) -> Mbti? {
        let innerChar = target[target.index(target.startIndex, offsetBy: 0)]
        let recogChar = target[target.index(target.startIndex, offsetBy: 1)]
        let judgeChar = target[target.index(target.startIndex, offsetBy: 2)]
        let lifeChar = target[target.index(target.startIndex, offsetBy: 3)]
        
        guard let innerType = InnerType(rawValue: String(innerChar)),
              let recogType = RecognizeType(rawValue: String(recogChar)),
              let judgeType = JudgementType(rawValue: String(judgeChar)),
              let lifeChar = LifeStyleType(rawValue: String(lifeChar)) else { return nil }
        return Mbti(
            innerType: innerType,
            recognizeType: recogType,
            judgementType: judgeType,
            lifeStyleType: lifeChar
        )
    }
}
