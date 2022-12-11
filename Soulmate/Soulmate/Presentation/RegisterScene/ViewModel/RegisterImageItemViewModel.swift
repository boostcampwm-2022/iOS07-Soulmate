//
//  RegisterImageItemViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/12.
//

import Foundation

struct RegisterImageItemViewModel: Hashable {
    var index: Int
    var data: Data?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}
