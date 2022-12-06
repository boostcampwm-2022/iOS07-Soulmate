//
//  LoadDetailInfoUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

protocol DownLoadDetailInfoUseCase {
    func downloadMyDetailInfo() async throws -> RegisterUserInfo
    func downloadDetailInfo(userUid: String) async throws -> RegisterUserInfo
}
