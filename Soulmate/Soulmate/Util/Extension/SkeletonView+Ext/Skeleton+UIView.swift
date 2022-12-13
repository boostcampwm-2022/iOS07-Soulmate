//
//  Skeleton+UIView.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/12/13.
//

import UIKit

// MARK: UIView Constraint 탐색

extension UIView {
    
    var definedMaxBounds: CGRect {
        if let parentStackView = (superview as? UIStackView) {
            var origin: CGPoint = .zero
            switch parentStackView.alignment {
            case .trailing:
                origin.x = definedMaxWidth
            default:
                break
            }
            return CGRect(origin: origin, size: definedMaxSize)
        }
        return CGRect(origin: .zero, size: definedMaxSize)
    }
    
    var definedMaxSize: CGSize {
        CGSize(width: definedMaxWidth, height: definedMaxHeight)
    }
    
    var definedMaxWidth: CGFloat {
        let constraintsMaxWidth = widthConstraints
            .map { return $0.constant }
            .max() ?? 0

        return max(frame.size.width, constraintsMaxWidth)
    }
    
    var definedMaxHeight: CGFloat {
        let constraintsMaxHeight = heightConstraints
            .map { $0.constant }
            .max() ?? 0

        return max(frame.size.height, constraintsMaxHeight)
    }
    
    var widthConstraints: [NSLayoutConstraint] {
        nonContentSizeLayoutConstraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.width }
    }
    
    var heightConstraints: [NSLayoutConstraint] {
        nonContentSizeLayoutConstraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.height }
    }
    
    var nonContentSizeLayoutConstraints: [NSLayoutConstraint] {
        constraints.filter({ "\(type(of: $0))" != "NSContentSizeLayoutConstraint" })
    }
}


// MARK: skeletonLayer 생성 및 추가 (layoutSubview에서 실행)

extension UIView {
    
    func addSkeletonLayer() {
        let skeletonLayer = SkeletonLayer(animationType: self.skeletonAnimationType, skeletonHolder: self)
        self.skeletonLayer = skeletonLayer

        layer.insertSkeletonLayer(
            skeletonLayer,
            atIndex: UInt32.max
        ) { [weak self] in
            guard let self = self else { return }
            (self as? UITextView)?.setContentOffset(.zero, animated: false)
            self.startSkeletonAnimation()
        }
    }
    
    func removeSkeletonLayer() {
        skeletonLayer?.stopAnimation()
        skeletonLayer?.removeLayer { [weak self] in
            self?.skeletonLayer = nil
        }
    }
    
    func skeletonLayoutSubviews() {
        guard Thread.isMainThread else { return }
        layoutSkeletonIfNeeded()
    }
    
    func layoutSkeletonIfNeeded() {
        recursiveLayoutSkeletonIfNeeded(root: self)
    }
    
    func recursiveLayoutSkeletonIfNeeded(root: UIView? = nil) {
        skeletonLayer?.layoutIfNeeded()
        startSkeletonAnimation()
        subviewsSkeletonables.forEach {
            $0.recursiveLayoutSkeletonIfNeeded()
        }
    }
}

extension UIView {
    
    // 제일 최상단 뷰에서 실행
    func showSkeleton() {
        guard !isRootSkeletonActive else { return }
        recursiveShowSkeleton(root: self)
        isRootSkeletonActive = true
    }
    
    func recursiveShowSkeleton(root: UIView? = nil) {
        if isSkeletonAnimatable {
            showSkeletonIfNotActive()
        }
        subviewsSkeletonables.forEach { subViews in
            subViews.recursiveShowSkeleton()
        }
    }
    
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
    func hideSkeleton() {
        guard isRootSkeletonActive else { return }
        recursiveHideSkeleton()
        isRootSkeletonActive = false
    }
    
    func recursiveHideSkeleton(root: UIView? = nil) {
        subviewsSkeletonables.forEach {
            $0.recursiveHideSkeleton()
        }
        
        removeSkeletonLayer()
    }
}

// MARK: Animation Start

extension UIView {
    func startSkeletonAnimation() {
        subviewsSkeletonables.forEach {
            $0.startSkeletonAnimation()
        }
        guard let layer = self.skeletonLayer else { return }
        layer.start()
    }
}

// MARK: ext Properties

extension UIView {
    
    var subviewsSkeletonables: [UIView] {
        subviews.filter { $0.isRecursiveSkeletonable }
    }
    
    private struct KeyHolder {
        static var isRecursiveSkeletonable: UInt8 = 0
        static var skeletonLayer: UInt8 = 1
        static var isSkeletonAnimatable: UInt8 = 2
        static var skeletonAnimationType: UInt8 = 3
        static var isRootSkeletonActive: UInt8 = 4
    }
    
    var isRecursiveSkeletonable: Bool {
        get {
            (objc_getAssociatedObject(self, &KeyHolder.isRecursiveSkeletonable) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &KeyHolder.isRecursiveSkeletonable, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    var skeletonLayer: SkeletonLayer? {
        get {
            (objc_getAssociatedObject(self, &KeyHolder.skeletonLayer) as? SkeletonLayer)
        }
        set {
            objc_setAssociatedObject(self, &KeyHolder.skeletonLayer, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    var isSkeletonAnimatable: Bool {
        get {
            (objc_getAssociatedObject(self, &KeyHolder.isSkeletonAnimatable) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &KeyHolder.isSkeletonAnimatable, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    var skeletonAnimationType: AnimationType {
        get {
            (objc_getAssociatedObject(self, &KeyHolder.skeletonAnimationType) as? AnimationType) ?? .flash
        }
        set {
            objc_setAssociatedObject(self, &KeyHolder.skeletonAnimationType, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    var isRootSkeletonActive: Bool {
        get {
            (objc_getAssociatedObject(self, &KeyHolder.isRootSkeletonActive) as? Bool) ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &KeyHolder.isRootSkeletonActive, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}
