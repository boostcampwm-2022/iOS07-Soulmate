//
//  AuthUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/16.
//

import Foundation

protocol PhoneSignInUseCase {
    func verifyPhoneNumber(phoneNumber: String) async throws -> String
    func certifyWithSMSCode(certificationCode: String) async throws
}
