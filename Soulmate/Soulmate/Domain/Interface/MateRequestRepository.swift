//
//  MateRequestRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import FirebaseFirestore

protocol MateRequestRepository {
    func sendMateRequest(request: SendMateRequest) async throws
    func listenOthersRequest(userId: String) -> Query
    func deleteMateRequest(requestId: String) async throws
}
