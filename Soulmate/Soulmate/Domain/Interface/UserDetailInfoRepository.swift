//
//  UserDetailInfoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/23.
//

import Foundation

protocol UserDetailInfoRepository {
    func uploadDetailInfo(userUid: String, registerUserInfo: UserDetailInfo) async throws
    func downloadDetailInfo(userUid: String) async throws -> UserDetailInfo
}
