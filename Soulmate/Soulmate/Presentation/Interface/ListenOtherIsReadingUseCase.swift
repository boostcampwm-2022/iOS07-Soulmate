//
//  ListenOtherIsReadingUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/30.
//

import Combine

protocol ListenOtherIsReadingUseCase {
    var otherRead: PassthroughSubject<String, Never> { get }
    
    func removeListen()
    func listenOtherIsReading()
}
