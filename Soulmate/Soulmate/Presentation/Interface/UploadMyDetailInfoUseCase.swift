//
//  UploadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

protocol UploadMyDetailInfoUseCase {
    func uploadDetailInfo(registerUserInfo: UserDetailInfo) async throws
}
