//
//  ChatRoomRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Foundation

protocol ChatRoomRepository {
    func createChatRoom(from info: ChatRoomInfo) async throws
}
