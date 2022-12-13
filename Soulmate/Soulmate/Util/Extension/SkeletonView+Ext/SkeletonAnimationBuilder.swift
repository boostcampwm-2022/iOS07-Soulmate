//
//  SkeletonAnimationBuilder.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/13.
//

import UIKit

public class SkeletonAnimationBuilder {
    
    public init() { }
    
    func slideAnimation(duration: CFTimeInterval = 1.2) -> CAAnimation {
        let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnim.fromValue = CGPoint(x: -1, y: 0.5)
        startPointAnim.toValue = CGPoint(x: 1, y: 0.5)

        let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnim.fromValue = CGPoint(x: 0, y: 0.5)
        endPointAnim.toValue = CGPoint(x: 2, y: 0.5)
        
        let delay = CABasicAnimation()

        let animGroup = CAAnimationGroup()
        animGroup.animations = [startPointAnim, endPointAnim, delay]
        animGroup.duration = duration
        animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animGroup.repeatCount = .infinity
        animGroup.autoreverses = false
        animGroup.isRemovedOnCompletion = false
        
        
        return animGroup
    }
    
    func flashAnimation() -> CAAnimation {
        let animationDuration: CFTimeInterval = 1.2
        
        let animation1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        animation1.fromValue = UIColor.lightGray.cgColor
        animation1.toValue = UIColor.gray.cgColor
        animation1.duration = animationDuration
        animation1.beginTime = 0.0
        
        let animation2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        animation2.fromValue = UIColor.gray.cgColor
        animation2.toValue = UIColor.lightGray.cgColor
        animation2.duration = animationDuration
        animation2.beginTime = animation1.beginTime + animation1.duration
        
        let group = CAAnimationGroup()
        group.animations = [animation1, animation2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = animation2.beginTime + animation2.duration
        group.isRemovedOnCompletion = false

        group.beginTime = 0.0
        return group
    }
}
