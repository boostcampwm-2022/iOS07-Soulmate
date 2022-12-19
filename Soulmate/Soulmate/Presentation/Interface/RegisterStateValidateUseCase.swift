//
//  RegisterStateValidateUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

protocol RegisterStateValidateUseCase {
    func validateRegisterState(registerUserInfo: UserDetailInfo) -> RegisterState
}
