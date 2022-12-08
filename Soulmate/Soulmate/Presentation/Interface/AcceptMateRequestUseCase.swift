//
//  AcceptMateRequestUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/08.
//

import Foundation

protocol AcceptMateRequestUseCase {
    func acceptMateRequest(_ request: ReceivedMateRequest) async throws
}
