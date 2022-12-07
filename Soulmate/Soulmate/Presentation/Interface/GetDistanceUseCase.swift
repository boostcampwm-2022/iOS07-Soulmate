//
//  GetDistanceUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation
import Combine

protocol GetDistanceUseCase {
    func getDistance() -> Double
    func getDistancePublisher() -> AnyPublisher<Double, Never>
}
