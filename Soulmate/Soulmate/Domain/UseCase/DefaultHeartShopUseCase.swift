//
//  HeartShopUseCase.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/05.
//

import Foundation
import FirebaseAuth

protocol HeartShopUseCase {
    
}

class DefaultHeartShopUseCase: HeartShopUseCase {
    let auth = Auth.auth()
    
    func userUid() -> String? {
        return auth.currentUser?.uid
    }
}
