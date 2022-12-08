//
//  EnterChatRoomUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import FirebaseFirestore

protocol EnterChatRoomUseCase {
    func updateEnterState(_ state: Bool)
}
