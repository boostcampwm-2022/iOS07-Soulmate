//
//  ConvertToSha256UseCase.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/19.
//

import Foundation

protocol ConvertToSha256UseCase {
    func execute(_ input: String) -> String
}
