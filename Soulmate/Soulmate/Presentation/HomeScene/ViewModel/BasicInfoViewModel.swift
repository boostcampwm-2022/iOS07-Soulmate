//
//  BasicInfoViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/12/07.
//

import Foundation

struct BasicInfoViewModel: Hashable {
    static func == (lhs: BasicInfoViewModel, rhs: BasicInfoViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID().uuidString
    var height: Int
    var mbti: Mbti
    var drink: DrinkingType
    var smoke: SmokingType
}
