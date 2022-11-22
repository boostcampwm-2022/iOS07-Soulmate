//
//  LoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine

protocol LoadChattingRoomListUseCase {
    var chattingRoomList: CurrentValueSubject<[ChattingRoomInfo], Never> { get }
    
    func loadChattingRooms()
}
