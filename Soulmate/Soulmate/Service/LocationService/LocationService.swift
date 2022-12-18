//
//  CLLocationService.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation
import Combine

protocol LocationService {
    var locationSubject: CurrentValueSubject<Location?, Never> { get }
    var authSubject: PassthroughSubject<Bool, Never> { get }
}
