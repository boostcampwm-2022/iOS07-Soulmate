//
//  DefaultSignOutUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation
import FirebaseAuth

class DefaultSignOutUseCase: SignOutUseCase {
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
