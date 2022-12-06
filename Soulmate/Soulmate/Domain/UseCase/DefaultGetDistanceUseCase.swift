//
//  DefaultGetDistanceUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation
import Combine

class DefaultGetDistanceUseCase: GetDistanceUseCase {
    let userDefaultRepository: UserDefaultsRepository
    
    init(userDefaultRepository: UserDefaultsRepository) {
        self.userDefaultRepository = userDefaultRepository
    }
    
    func getDistance() -> Double? {
        return userDefaultRepository.get(key: "distance")
    }
    
    func getDistancePublisher() -> AnyPublisher<Double, Never> {
        return userDefaultRepository.valuePublisher(path: \.distance)
    }
}
