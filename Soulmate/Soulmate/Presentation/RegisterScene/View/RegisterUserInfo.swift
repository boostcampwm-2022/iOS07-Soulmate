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
    var imageList: [Data]?
}

struct Mbti {
    var innerType: InnerType
    var recognizeType: RecognizeType
    var judgementType: JudgementType
    var lifeStyleType: LifeStyleType
}

enum InnerType: String {
    case i
    case e
}

enum RecognizeType: String {
    case n
    case s
}

enum JudgementType: String {
    case t
    case f
}

enum LifeStyleType: String {
    case p
    case j
}
