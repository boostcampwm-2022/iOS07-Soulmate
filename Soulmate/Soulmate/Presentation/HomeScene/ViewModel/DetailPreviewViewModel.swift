//
//  DetailPreviewViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/07.
//

import Foundation

struct DetailPreviewViewModel: Hashable {
    let uid: String
    let name: String
    let age: String
    let distance: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
