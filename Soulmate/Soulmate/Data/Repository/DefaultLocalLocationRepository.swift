//
//  DefaultLocalLocationRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import Combine

class DefaultLocalLocationRepository: LocalLocationRepository {
    let locationService: LocationService
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func authorizationPublisher() -> AnyPublisher<Bool, Never> {
        return locationService.authSubject.eraseToAnyPublisher()
    }
    
    func locationPublisher() -> AnyPublisher<Location, Never> {
        return locationService.locationSubject.eraseToAnyPublisher()
    }
}
