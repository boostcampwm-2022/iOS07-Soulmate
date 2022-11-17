//
//  AuthUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/15.
//

import Foundation
import FirebaseAuth

class DefaultAuthUseCase: AuthUseCase {
    
    func register() {
        
    }
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    func verifyPhoneNumber(phoneNumber: String) async throws -> String {
        let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        UserDefaults.standard.set(verificationID, forKey: "verificationID")
        return verificationID
    }
    
    func certifyWithSMSCode(certificationCode: String) async throws {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else {
            throw AuthError.noVerificationIDError
        }
                
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
}
