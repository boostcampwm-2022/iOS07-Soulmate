//
//  FCMRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

protocol FCMRepository {
    func updateFCMToken(for uid: String, token: String)
}
