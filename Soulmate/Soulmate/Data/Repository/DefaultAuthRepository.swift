//
//  DefaultAuthRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation
import FirebaseAuth

class DefaultAuthRepository: AuthRepository {

    let auth = Auth.auth()
    
    func signIn(with credential: AuthCredential) async throws {
        try await auth.signIn(with: credential)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func currentUid() throws -> String {
        guard let uid = auth.currentUser?.uid else {
            throw AuthError.noCurrentUserError
        }
        return uid
    }
    
    func verifyPhoneNumber(number: String) async throws -> String {
        return try await PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil)
    }
    
    func buildCredential(verificationID: String, verificationCode: String) -> AuthCredential {
        return PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
    }
    
}

// TODO: 에러 따로 빼서 정의하기
enum AuthError: Error {
    case noVerificationIDError
    case noCurrentUserError
}
