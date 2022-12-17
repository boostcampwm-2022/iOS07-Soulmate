//
//  DefaultListenOthersChattingUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/28.
//

import Combine

final class DefaultListenOthersChattingUseCase: ListenOthersChattingUseCase {        
    
    private let info: ChatRoomInfo
    private let chattingRepository: ChattingRepository
    private let authRepository: AuthRepository
    var othersMessages: PassthroughSubject<[Chat], Never>
    
    init(
        with info: ChatRoomInfo,
        chattingRepository: ChattingRepository,
        authRepository: AuthRepository) {
        
            self.info = info
            self.chattingRepository = chattingRepository
            self.authRepository = authRepository
            
            self.othersMessages = chattingRepository.othersMessages
    }

    func removeListen() {
        chattingRepository.removeChattingListen()
    }
    
    func listenOthersChattings() {
        guard let chatRoomId = info.documentId,
              let uid = try? authRepository.currentUid() else { return }
        
        chattingRepository.listenOthersChattings(from: chatRoomId, uid: uid)
    }
}
