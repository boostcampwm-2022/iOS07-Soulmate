//
//  Mbti.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation

struct Mbti {
    var innerType: InnerType
    var recognizeType: RecognizeType
    var judgementType: JudgementType
    var lifeStyleType: LifeStyleType
}

enum InnerType: String, CaseIterable {
    case i = "I"
    case e = "E"
}

enum RecognizeType: String, CaseIterable {
    case n = "N"
    case s = "S"
}

enum JudgementType: String, CaseIterable {
    case t = "T"
    case f = "F"
}

enum LifeStyleType: String, CaseIterable {
    case p = "P"
    case j = "J"
}

extension Mbti {
    func toString() -> String{
        return "\(self.innerType.rawValue)\(self.recognizeType.rawValue)\(self.judgementType.rawValue)\(self.lifeStyleType.rawValue)"
    }
}

extension Mbti {
    static func toDomain(target: String) -> Mbti? {
        guard target.count == 4 else { return nil }
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
