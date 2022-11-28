//
//  LoadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import FirebaseFirestore

protocol LoadChattingsUseCase {
    var initLoadedchattings: CurrentValueSubject<[Chat], Never> { get }        
    
    func loadChattings()     
}
