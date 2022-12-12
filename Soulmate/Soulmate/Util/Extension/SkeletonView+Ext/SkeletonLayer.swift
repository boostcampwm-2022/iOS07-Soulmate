//
//  SkeletonLayer.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/13.
//

import UIKit

struct SkeletonLayer {
    var maskLayer: CAGradientLayer
    var animation: CAAnimation?
    var animationKey: String
    
    private weak var holder: UIView?
    
    init(animationType: AnimationType, skeletonHolder holder: UIView) {
        self.holder = holder
        self.maskLayer = animationType.layer
        
        self.animation = animationType.animation
        self.maskLayer.anchorPoint = .zero
        self.maskLayer.bounds = holder.definedMaxBounds
        self.holder = holder
        self.animationKey = animationType.animationKey
    }
    
    func layoutIfNeeded() {
        if let bounds = holder?.definedMaxBounds {
            maskLayer.bounds = bounds
        }
        if let radius = holder?.layer.cornerRadius {
            maskLayer.cornerRadius = radius
        }
    }
    
    func start(completion: (() -> Void)? = nil) {
        guard let animation = animation else { return }
        DispatchQueue.main.async { CATransaction.begin() }
        DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
        maskLayer.add(animation, forKey: animationKey)
        DispatchQueue.main.async { CATransaction.commit() }
    }
    
    func stopAnimation() {
        maskLayer.removeAnimation(forKey: animationKey)
    }

    
    func removeLayer(completion: (() -> Void)? = nil) {
        maskLayer.setOpacity(from: 1, to: 0, duration: 3) {
            self.maskLayer.removeFromSuperlayer()
            completion?()
        }
    }
}
