//
//  LoadUnreadChattingsUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/29.
//

import Combine
import FirebaseFirestore

protocol LoadUnreadChattingsUseCase {
    var unreadChattings: PassthroughSubject<[Chat], Never> { get }
    
    func loadUnreadChattings()
}
