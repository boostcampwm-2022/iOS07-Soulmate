//
//  ModificationImageViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation

struct ModificationImageViewModel: Hashable {
    var index: Int
    var imageData: Data
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.index)
    }
}
