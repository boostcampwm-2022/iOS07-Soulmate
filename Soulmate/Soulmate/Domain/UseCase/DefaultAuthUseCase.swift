//
//  DefaultAuthUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/02.
//

import Foundation
import FirebaseAuth

final class DefaultAuthUseCase: AuthUseCase {
    let auth = Auth.auth()
    
    func userUid() -> String? {
        return auth.currentUser?.uid
    }
}
