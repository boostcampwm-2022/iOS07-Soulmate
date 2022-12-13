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
    private let authRepository: AuthRepository
    private let fcmRepository: FCMRepository
    
    init(
        mateRequestRepository: MateRequestRepository,
        userPreviewRepository: UserPreviewRepository,
        authRepository: AuthRepository,
        fcmRepository: FCMRepository
    ) {
        self.mateRequestRepository = mateRequestRepository
        self.authRepository = authRepository
        self.userPreviewRepository = userPreviewRepository
        self.fcmRepository = fcmRepository
    }
 
    func sendMateRequest(mateId: String) async throws {
                
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
            await fcmRepository.sendMateRequestFCM(to: mateId, name: name)
        } catch {
            print("대화요청 실패")
        }
    }
}

protocol SendMateRequestUseCase {
    func sendMateRequest(mateId: String) async throws
}
