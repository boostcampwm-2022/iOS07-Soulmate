//
//  ChatRoomRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Combine

protocol ChatRoomRepository {
    var chatRoomList: CurrentValueSubject<[ChatRoomInfo], Never> { get }
    
    func removeListen()
    func loadChatRooms(of uid: String)
    func createChatRoom(from info: ChatRoomInfo) async throws
    func deleteChatRoom(_ info: ChatRoomInfo) async throws
}
