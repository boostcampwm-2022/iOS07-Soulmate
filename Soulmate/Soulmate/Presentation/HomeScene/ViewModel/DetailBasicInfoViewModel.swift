//
//  BasicInfoViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/12/07.
//

import Foundation

struct DetailBasicInfoViewModel: Hashable {
    
    var uid: String
    var height: String
    var mbti: String
    var drink: String
    var smoke: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
