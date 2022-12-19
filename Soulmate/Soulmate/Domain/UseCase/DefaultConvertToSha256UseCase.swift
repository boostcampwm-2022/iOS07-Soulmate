//
//  ConvertToSha256UseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation
import CryptoKit

final class DefaultConvertToSha256UseCase: ConvertToSha256UseCase {
    @available(iOS 13, *)
    func execute(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashString
    }
}
