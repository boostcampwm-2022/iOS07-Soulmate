//
//  AuthUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import FirebaseAuth

final class DefaultPhoneSignInUseCase: PhoneSignInUseCase {
    
    let userDefaultsRepository: UserDefaultsRepository
    let authRepository: AuthRepository
    
    init(
        userDefaultsRepository: UserDefaultsRepository,
        authRepository: AuthRepository
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.authRepository = authRepository
    }
    
    func verifyPhoneNumber(phoneNumber: String) async throws -> String {
        let verificationID = try await authRepository.verifyPhoneNumber(number: phoneNumber)
        userDefaultsRepository.set(key: "verificationID", value: verificationID)
        return verificationID
    }
    
    func certifyWithSMSCode(certificationCode: String) async throws {
        guard let verificationID: String = userDefaultsRepository.get(key: "verificationID") else { return }
        userDefaultsRepository.remove(key: "verificationID")

        let credentail = authRepository.buildCredential(
            verificationID: verificationID,
            verificationCode: certificationCode
        )
        
        try await authRepository.signIn(with: credentail)
    }
}
