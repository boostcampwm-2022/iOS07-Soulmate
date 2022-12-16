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

// 스켈레톤 탐색 관련
extension UIView {
    func recursiveSearchSubviews(toDo: (UIView) -> Void) {
        subviews.forEach { subview in
            subview.recursiveSearchSubviews(toDo: toDo)
        }
        toDo(self)
    }
}

extension UIView {

    private struct KeyHolder {
        static var isRootSkeletonActive: UInt8 = 0
    }
    
    var isRootSkeletonActive: Bool {
        get { (objc_getAssociatedObject(self, &KeyHolder.isRootSkeletonActive) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &KeyHolder.isRootSkeletonActive, newValue, .OBJC_ASSOCIATION_COPY) }
    }
}

extension UIView {
    func showSkeleton() {
        guard !isRootSkeletonActive else { return }
        recursiveSearchSubviews { view in
            if let skeleton = view as? Skeletonable {
                skeleton.showSkeletonIfNotActive()
            }
        }
        isRootSkeletonActive = true
    }
    
    func hideSkeleton() {
        guard isRootSkeletonActive else { return }
        recursiveSearchSubviews { view in
            if let skeleton = view as? Skeletonable {
                skeleton.removeSkeletonLayer()
            }
        }
        isRootSkeletonActive = false
    }
}
