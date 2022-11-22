//
//  LoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine

protocol LoadChattingRoomListUseCase {
    var chattingRoomList: CurrentValueSubject<[ChatRoomInfo], Never> { get }
    
    func loadChattingRooms()
}
