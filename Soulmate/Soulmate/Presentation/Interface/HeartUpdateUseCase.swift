//
//  HeartUpdateUseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation

protocol HeartUpdateUseCase {
    func registerHeart(heart: Int) async throws
    func updateHeart(heart: Int) async throws
}
