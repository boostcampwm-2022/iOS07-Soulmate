//
//  SendMessageUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import Combine
import Foundation

protocol SendMessageUseCase {
    var sendButtonEnabled: CurrentValueSubject<Bool, Never> { get }
    var myMessage: PassthroughSubject<Chat, Never> { get }
    var messageSended: PassthroughSubject<Chat, Never> { get }
    
    func updateMessage(_ text: String)    
    func sendMessage() async
}
