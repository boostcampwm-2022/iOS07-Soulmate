//
//  FetchMateChatImageKeyUseCase.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/10.
//

import Foundation

protocol FetchMateChatImageKeyUseCase {
    func fetchMateChatImageKey() async -> String?
}
