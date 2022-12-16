//
//  Skeletonable.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/16.
//

import UIKit

protocol Skeletonable: UIView {
    init(animation: AnimationType)
    var skeletonLayer: SkeletonLayer? { get set }
    var animationType: AnimationType { get set }
}

// MARK: skeletonLayer 생성 및 추가 (layoutSubview에서 실행)
extension Skeletonable {
    
    func addSkeletonLayer() {
        let skeletonLayer = SkeletonLayer(animationType: self.animationType, skeletonHolder: self)
        self.skeletonLayer = skeletonLayer
        layer.insertSkeletonLayer(
            skeletonLayer,
            atIndex: UInt32.max
        ) { [weak self] in
            guard let self = self else { return }
            (self as? UITextView)?.setContentOffset(.zero, animated: false)
            self.skeletonLayer?.start()
        }
    }
    
    func removeSkeletonLayer() {
        skeletonLayer?.stopAnimation()
        skeletonLayer?.removeLayer { [weak self] in
            self?.skeletonLayer = nil
        }
    }
}

extension Skeletonable {
    func layoutSkeletonIfNeeded() {
        skeletonLayer?.layoutIfNeeded()
        skeletonLayer?.start()
    }
}


extension Skeletonable {

    func showSkeletonIfNotActive(root: UIView? = nil) {
        prepareViewForSkeleton()
        addSkeletonLayer()
    }
    
    func prepareViewForSkeleton() {
        UIView.transition(
            with: self,
            duration: 1,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.backgroundColor = .clear
            },
            completion: nil
        )
    }

}
