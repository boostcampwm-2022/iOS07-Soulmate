//
//  DefaultSendMateRequestUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/08.
//

import Foundation

final class DefaultSendMateRequestUseCase: SendMateRequestUseCase {
    
    private let mateRequestRepository: MateRequestRepository
    private let userPreviewRepository: UserPreviewRepository
    private let userHeartInfoRepository: UserHeartInfoRepository
    private let authRepository: AuthRepository
    private let fcmRepository: FCMRepository
    
    init(
        mateRequestRepository: MateRequestRepository,
        userPreviewRepository: UserPreviewRepository,
        userHeartInfoRepository: UserHeartInfoRepository,
        authRepository: AuthRepository,
        fcmRepository: FCMRepository
    ) {
        self.mateRequestRepository = mateRequestRepository
        self.authRepository = authRepository
        self.userPreviewRepository = userPreviewRepository
        self.fcmRepository = fcmRepository
        self.userHeartInfoRepository = userHeartInfoRepository
    }
 
    func sendMateRequest(mateId: String) async throws {
        
        // TODO: 하트가 부족하면 못보내게 막기
        
        let userId = try authRepository.currentUid()
        let userPreview = try await userPreviewRepository.downloadPreview(userUid: userId)
        
        guard let name = userPreview.name,
              let imageKey = userPreview.imageKey else { return }
        
        let sendMateRequest = SendMateRequest(
            createdAt: Date.now,
            requestUserId: userId,
            mateName: name,
            mateProfileImage: imageKey,
            receivedUserId: mateId
        )
        
        do {
            try await mateRequestRepository.sendMateRequest(request: sendMateRequest)
            try await userHeartInfoRepository.updateHeart(uid: userId, heartInfo: UserHeartInfo(heart: -20))
            await fcmRepository.sendMateRequestFCM(to: mateId, name: name)
        } catch {
            print("대화요청 실패")
        }
    }
}

protocol SendMateRequestUseCase {
    func sendMateRequest(mateId: String) async throws
}
