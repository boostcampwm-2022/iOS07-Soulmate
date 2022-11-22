//
//  ProfilePhotoRepository.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

protocol ProfilePhotoRepository {
    func downloadPicture(fileName: String) async throws -> Data
    func uploadPicture(fileName: String, data: Data) async throws
}
