//
//  ImageKeyUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/29.
//

import Foundation

protocol ImageKeyUseCase {
    
    func imageKey(from uid: String) async -> String?
}
