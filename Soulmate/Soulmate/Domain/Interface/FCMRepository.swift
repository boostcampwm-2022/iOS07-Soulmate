//
//  FCMRepository.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/12.
//

import Foundation

protocol FCMRepository {
    func sendChattingFCM(to mateId: String, title: String, message: String) async
    func sendMateRequestFCM(to mateId: String, name: String) async
    func updateFCMToken(for uid: String, token: String) async throws
}
