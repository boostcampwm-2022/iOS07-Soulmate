//
//  LoadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

protocol LoadDetailInfoUseCase {
    func loadDetailInfo(userUid: String) async throws -> RegisterUserInfo
}
