//
//  HomePreviewViewModel.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/07.
//
import Foundation

struct HomePreviewViewModel: Hashable {
    let uid: String
    let imageKey: String
    let name: String
    let age: String
    let address: String?
    let distance: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

struct HomePreviewViewModelWrapper: Hashable {
    var index: Int
    var previewViewModel: HomePreviewViewModel?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}
