//
//  FetchImageUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/29.
//

import Foundation

protocol FetchImageUseCase {
    func fetchImage(for key: String) async -> Data?
}
