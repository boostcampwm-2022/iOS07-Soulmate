//
//  DetailViewModel.swift
//  Soulmate
//
//  Created by termblur on 2022/11/21.
//

import Foundation

final class DetailViewModel {
    let userInfo: RegisterUserInfo
    let distance: Int
    
    init(userInfo: RegisterUserInfo, distance: Int) {
        self.userInfo = userInfo
        self.distance = distance
    }
    
}

extension DetailViewModel {
    struct Input { }
    
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
