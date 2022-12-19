//
//  DefaultAppleSignInUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import FirebaseAuth

final class DefaultAppleSignInUseCase: AppleSignInUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(idToken: String, nonce: String) async throws {
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idToken,
            rawNonce: nonce
        )
        try await authRepository.signIn(with: credential)
    }
}
