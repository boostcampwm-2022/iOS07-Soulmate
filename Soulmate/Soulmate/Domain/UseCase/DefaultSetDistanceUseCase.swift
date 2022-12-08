//
//  DefaultSetDistanceUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation

class DefaultSetDistanceUseCase: SetDistanceUseCase {
    let userDefaultRepository: UserDefaultsRepository
    
    init(userDefaultRepository: UserDefaultsRepository) {
        self.userDefaultRepository = userDefaultRepository
    }
    
    func setDistance(distance: Double) {
        userDefaultRepository.set(key: "distance", value: distance)
    }
}
