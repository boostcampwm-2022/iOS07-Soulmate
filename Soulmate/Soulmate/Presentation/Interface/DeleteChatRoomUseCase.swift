//
//  DeleteChatRoomUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/13.
//

import Foundation

protocol DeleteChatRoomUseCase {
    
    func execute(chatRoomInfo: ChatRoomInfo) async
}
