//
//  ModificationImageViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/01.
//

import Foundation

struct ModificationImageViewModel: Hashable {
    var uuid = UUID().uuidString
    var imageData: Data
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
