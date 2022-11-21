//
//  LoadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine

protocol LoadChattingsUseCase {
    var loadedNewChattings: PassthroughSubject<Bool, Never> { get }
    var loadedChattings: CurrentValueSubject<[Chat], Never> { get }
    
    func loadChattings()
}
