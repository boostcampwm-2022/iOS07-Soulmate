//
//  DeleteMateRequestUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/14.
//

import Foundation

final class DefaultDeleteMateRequestUseCase: DeleteMateRequestUseCase {
    
    private let mateRequestRepository: MateRequestRepository
    
    init(mateRequestRepository: MateRequestRepository) {
        self.mateRequestRepository = mateRequestRepository
    }
    
    func execute(requestId: String) async throws {
        try? await mateRequestRepository.deleteMateRequest(requestId: requestId)
    }
}
