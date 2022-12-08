//
//  ViewModelable.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/08.
//

import Foundation

protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    associatedtype Action
    
    func setActions(actions: Action)
    func transform(input: Input) -> Output
}
