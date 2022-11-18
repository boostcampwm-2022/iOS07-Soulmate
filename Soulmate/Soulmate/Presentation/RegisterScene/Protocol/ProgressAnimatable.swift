//
//  ProgressAnimatable.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/17.
//

import UIKit

protocol ProgressAnimatable: UIViewController {
    
    func preset()
    func reset()
    func progressingComponents() -> [UIView]
    func bar() -> ProgressBar
}
