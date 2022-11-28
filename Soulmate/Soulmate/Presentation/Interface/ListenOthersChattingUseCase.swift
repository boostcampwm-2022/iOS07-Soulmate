//
//  ListenOthersChattingUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine
import FirebaseFirestore

protocol ListenOthersChattingUseCase {
    var newMessages: PassthroughSubject<[Chat], Never> { get }
    
    func listenOthersChattings()
}
