//
//  LoadPrevChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine
import FirebaseFirestore

protocol LoadPrevChattingsUseCase {
    var prevChattings: CurrentValueSubject<[Chat], Never> { get }
    var loadedPrevChattingCount: PassthroughSubject<Int, Never> { get }
    
    func loadPrevChattings()
}
