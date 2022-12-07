//
//  LoadPrevChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine
import FirebaseFirestore

protocol LoadPrevChattingsUseCase {    
    
    func loadPrevChattings() async -> [Chat]
}
