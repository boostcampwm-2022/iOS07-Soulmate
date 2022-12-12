//
//  AnimationType.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/13.
//

import UIKit

// TODO: 그냥 config 구조체로 만들어도 될거같다
enum AnimationType {
    case gradient
    case flash
    case animationless

    var layer: CAGradientLayer {
        switch self {
        case .gradient:
            let layer = CAGradientLayer()
            layer.colors = [UIColor.systemGray2.cgColor, UIColor.systemGray5.cgColor, UIColor.systemGray2.cgColor]
            layer.locations = [0, 0.5, 1]
            return layer
        case .flash:
            return CAGradientLayer()
        case .animationless:
            let layer = CAGradientLayer()
            layer.backgroundColor = UIColor.systemGray3.cgColor
            return layer
        }
    }
    
    var animation: CAAnimation? {
        switch self {
        case .gradient:
            return SkeletonAnimationBuilder().slideAnimation()
        case .flash:
            return SkeletonAnimationBuilder().flashAnimation()
        case .animationless:
            return nil
        }
    }
    
    var animationKey: String {
        switch self {
        case .gradient:
            return "gradient"
        case .flash:
            return "flash"
        case .animationless:
            return "animationless"
        }
    }
}
