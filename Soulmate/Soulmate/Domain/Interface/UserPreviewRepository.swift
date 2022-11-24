//
//  UserPrevInfoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

protocol UserPreviewRepository {
    //func downloadFilteredUserPreviews() async throws -> [RegisterUserInfo]
    func uploadPreview(userUid: String, userPreview: UserPreview) async throws
    func updateLocation(userUid: String, location: Location) async throws
}
