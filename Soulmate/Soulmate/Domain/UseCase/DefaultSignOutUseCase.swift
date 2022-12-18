//
//  DefaultSignOutUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation
import FirebaseAuth

final class DefaultSignOutUseCase: SignOutUseCase {
    
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signOut() throws {
        try authRepository.signOut()
    }
}
