//
//  DetailViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/21.
//

import Foundation

struct DetailViewModel {
    var profile: Profile
    var greet: Greeting
    var info: BasicInfo
}

struct Profile {
    var name = "초록잎"
    var age = "25"
    var distance = "3km"
}

struct Greeting {
    var greeting = "솔직한 사람이 좋아요😋"
}

struct BasicInfo {
    var height = "161cm"
    var mbti = "ISFP"
    var drink = "가끔 마심"
    var smoke = "비흡연"
}
