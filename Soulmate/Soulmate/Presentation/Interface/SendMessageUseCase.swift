//
//  SendMessageUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine

protocol SendMessageUseCase {
    var sendButtonEnabled: CurrentValueSubject<Bool, Never> { get }
    
    func updateMessage(_ text: String)
}
