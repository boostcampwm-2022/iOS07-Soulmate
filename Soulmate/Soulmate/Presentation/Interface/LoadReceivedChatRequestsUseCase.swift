//
//  LoadReceivedChatRequestsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/24.
//

import Combine

protocol LoadReceivedChatRequestsUseCase {
    var requests: CurrentValueSubject<[ReceivedRequest], Never> { get }
    
    func listenRequests()
}
