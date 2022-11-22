//
//  LoadPictureUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/22.
//

import Foundation

protocol UploadPictureUseCase {
    func uploadPhotoData(photoData: [Data?]) async throws -> [String]?
}
