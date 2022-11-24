//
//  DownLoadPictureUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/24.
//

import Foundation

protocol DownLoadPictureUseCase {
    func downloadPhotoData(keyList: [String]) async throws -> [Data]
}
