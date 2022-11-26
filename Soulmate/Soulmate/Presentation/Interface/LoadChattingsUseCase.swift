//
//  LoadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine

protocol LoadChattingsUseCase {
    var chattings: CurrentValueSubject<[Chat], Never> { get }
    
    func loadChattings()
}
