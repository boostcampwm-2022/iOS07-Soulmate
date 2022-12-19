//
//  DefaultGetDistanceUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation
import Combine

final class DefaultGetDistanceUseCase: GetDistanceUseCase {
    let userDefaultRepository: UserDefaultsRepository
    
    init(userDefaultRepository: UserDefaultsRepository) {
        self.userDefaultRepository = userDefaultRepository
    }
    
    func getDistance() -> Double {
        guard let distance: Double = userDefaultRepository.get(key: "distance") else {
            // 없다면 초기값 생성
            userDefaultRepository.set(key: "distance", value: 20)
            return 20
        }
        return distance
    }
    
    func getDistancePublisher() -> AnyPublisher<Double, Never> {
        return userDefaultRepository.valuePublisher(path: \.distance)
    }
}
