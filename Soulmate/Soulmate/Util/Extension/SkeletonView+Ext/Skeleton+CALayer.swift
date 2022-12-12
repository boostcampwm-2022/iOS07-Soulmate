//
//  Skeleton+CALayer.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/13.
//

import UIKit

extension CALayer {

    func setOpacity(from: Int, to: Int, duration: TimeInterval, completion: (() -> Void)?) {
        DispatchQueue.main.async { CATransaction.begin() }
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
        add(animation, forKey: "setOpacityAnimation")
        DispatchQueue.main.async { CATransaction.commit() }
    }
    
    func insertSkeletonLayer(_ sublayer: SkeletonLayer, atIndex index: UInt32 , completion: (() -> Void)? = nil) {
        insertSublayer(sublayer.maskLayer, at: index)
        sublayer.maskLayer.setOpacity(from: 0, to: 1, duration: 1, completion: completion)
    }
}
