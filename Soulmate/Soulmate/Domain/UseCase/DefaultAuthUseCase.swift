//
//  DefaultAuthUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/02.
//

import Foundation
import FirebaseAuth

protocol AuthUseCase {
    func userUid() -> String?
}

class DefaultAuthUseCase: AuthUseCase {
    let auth = Auth.auth()
    
    func userUid() -> String? {
        return auth.currentUser?.uid
    }
}
