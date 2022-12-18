//
//  DefaultGetLocalLocationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import Combine

final class DefaultGetLocalLocationPublisherUseCase: GetLocalLocationPublisherUseCase {
    let localLocationRepository: LocalLocationRepository
    
    init(localLocationRepository: LocalLocationRepository) {
        self.localLocationRepository = localLocationRepository
    }
    
    func execute() -> AnyPublisher<Location, Never> {
        return localLocationRepository.locationPublisher()
    }
}
