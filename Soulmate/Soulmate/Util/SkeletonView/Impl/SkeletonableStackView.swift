//
//  SkeletonableStackView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/16.
//

import UIKit

final class SkeletonableStackView: UIStackView, Skeletonable {
    var skeletonLayer: SkeletonLayer?
    var animationType: AnimationType
    
    required init(animation: AnimationType) {
        self.animationType = animation
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSkeletonIfNeeded()
    }
}

