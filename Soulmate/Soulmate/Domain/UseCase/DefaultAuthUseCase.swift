//
//  AuthUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import FirebaseAuth

class DefaultPhoneSignInUseCase: PhoneSignInUseCase {
    
    let userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func verifyPhoneNumber(phoneNumber: String) async throws -> String {
        let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        userDefaultsRepository.set(key: "verificationID", value: verificationID)
        return verificationID
    }
    
    func certifyWithSMSCode(certificationCode: String) async throws {
        guard let verificationID: String = userDefaultsRepository.get(key: "verificationID") else { return }
        userDefaultsRepository.remove(key: "verificationID")
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: certificationCode
        )
        
        let result = try await Auth.auth().signIn(with: credential)
    }
}

// TODO: 에러 따로 빼서 정의하기
enum AuthError: Error {
    case noVerificationIDError
    case noCurrentUserError
}
