//
//  DefaultAcceptMateRequestUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Foundation

final class DefaultAcceptMateRequestUseCase: AcceptMateRequestUseCase {
    
    private let authRepository: AuthRepository
    private let userPreviewRepository: UserPreviewRepository
    private let chatRoomRepository: ChatRoomRepository
    
    init(
        authRepository: AuthRepository,
        userPreviewRepository: UserPreviewRepository,
        chatRoomRepository: ChatRoomRepository) {
            self.authRepository = authRepository
            self.userPreviewRepository = userPreviewRepository
            self.chatRoomRepository = chatRoomRepository
        }
    
    func acceptMateRequest(_ request: ReceivedMateRequest) async throws {
        let uid = request.receivedUserId
        let mateId = request.requestUserId
        let mateImage = request.mateProfileImage
        let mateName = request.mateName
        
        let myPreview = try await userPreviewRepository.downloadPreview(userUid: uid)
        guard let name = myPreview.name, let myImage = myPreview.imageKey else { return }

        var chatRoomInfo = ChatRoomInfo(
            userNames: [uid: name, mateId: mateName],
            userProfileImages: [uid: myImage, mateId: mateImage],
            userIds: [uid, mateId],
            unreadCount: [uid: 0.0, mateId: 0.0]
        )
        
        try await chatRoomRepository.createChatRoom(from: chatRoomInfo)
    }
}
