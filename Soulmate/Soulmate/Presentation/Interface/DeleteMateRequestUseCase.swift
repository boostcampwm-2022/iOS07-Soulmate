//
//  MateRequestUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/14.
//

import Foundation

protocol DeleteMateRequestUseCase {
    func execute(requestId: String) async throws
}
