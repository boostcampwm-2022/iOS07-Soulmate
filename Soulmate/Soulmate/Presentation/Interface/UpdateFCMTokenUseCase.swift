//
//  UpdateFCMTokenUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

protocol UpdateFCMTokenUseCase {
    
    func execute(token: String) async throws
}
