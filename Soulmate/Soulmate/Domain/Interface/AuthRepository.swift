//
//  AuthRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/06.
//

import Foundation
import FirebaseAuth

protocol AuthRepository {
    func signIn(with credential: AuthCredential) async throws
    func signOut() throws
    func currentUid() throws -> String
    func verifyPhoneNumber(number: String) async throws -> String
    func buildCredential(verificationID: String, verificationCode: String) -> AuthCredential
}
