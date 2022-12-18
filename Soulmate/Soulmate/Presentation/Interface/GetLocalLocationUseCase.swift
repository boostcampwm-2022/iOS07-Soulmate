//
//  GetLocalLocationUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import Combine

protocol GetLocalLocationPublisherUseCase {
    func execute() -> AnyPublisher<Location, Never>
}
