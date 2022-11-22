//
//  DefaultRegisterStateValidateUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

class DefaultRegisterStateValidateUseCase: RegisterStateValidateUseCase {
    func validateRegisterState(registerUserInfo: RegisterUserInfo) -> RegisterState {
        guard let _ = registerUserInfo.id,
              let _ = registerUserInfo.gender,
              let _ = registerUserInfo.nickName,
              let _ = registerUserInfo.birthDay,
              let _ = registerUserInfo.height,
              let _ = registerUserInfo.mbti,
              let _ = registerUserInfo.smokingType,
              let _ = registerUserInfo.drinkingType,
              let _ = registerUserInfo.aboutMe,
              let _ = registerUserInfo.imageList else { return .part(registerUserInfo) }
        return .done
    }
}
