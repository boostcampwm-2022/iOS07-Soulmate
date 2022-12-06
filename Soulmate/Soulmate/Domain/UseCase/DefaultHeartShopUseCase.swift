//
//  HeartShopUseCase.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/12/05.
//

import Foundation
import FirebaseAuth

protocol HeartShopUseCase {
    func chargeHeart(heart: Int) async
}

class DefaultHeartShopUseCase: HeartShopUseCase {
    
    let userPreviewRepository: UserPreviewRepository
    
    init(
        userPreviewRepository: UserPreviewRepository
    ) {
        self.userPreviewRepository = userPreviewRepository
    }
    
    func chargeHeart(heart: Int) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        try? await userPreviewRepository.updateHeart(
            userUid: uid,
            heart: heart
        )
    }
}
