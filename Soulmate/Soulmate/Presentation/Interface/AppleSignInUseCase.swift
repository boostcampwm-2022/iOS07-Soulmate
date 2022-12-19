//
//  AppleSignInUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation

protocol AppleSignInUseCase {
    func execute(idToken: String, nonce: String) async throws
}
