//
//  LocalLocationRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import Combine

protocol LocalLocationRepository {
    func authorizationPublisher() -> AnyPublisher<Bool, Never>
    func locationPublisher() -> AnyPublisher<Location, Never>
}
