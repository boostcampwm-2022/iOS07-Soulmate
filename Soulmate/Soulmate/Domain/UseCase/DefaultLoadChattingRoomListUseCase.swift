//
//  DefaultLoadChattingRoomListUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/22.
//

import Combine

final class DefaultLoadChattingRoomListUseCase: LoadChattingRoomListUseCase {
    
    var chattingRoomList = CurrentValueSubject<[ChattingRoomInfo], Never>(
        [
            ChattingRoomInfo(mateName: "Trash", mateProfileImage: nil, latestChatContent: "어떤 내용", lastChatDate: "오전 1:11")
        ]
    )
    
    func loadChattingRooms() {
        
    }
}
