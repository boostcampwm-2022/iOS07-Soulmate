//
//  ProgressAnimator.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/17.
//

import UIKit

class ProgressAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.3
    var operation: UINavigationController.Operation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        switch operation {
        case .push:
            guard let toVC = transitionContext.viewController(forKey: .to) as? ProgressAnimatable,
                  let fromVC = transitionContext.viewController(forKey: .from) as? ProgressAnimatable else {
                
                transitionContext.completeTransition(true)
                return
            }
            
            let toViewFrame = toVC.view.frame
            let fromViewFrame = fromVC.view.frame
            let fromSubViews = fromVC.progressingComponents()
            
            toVC.preset()
            
            toVC.view.center = CGPoint(
                x: toViewFrame.midX + toViewFrame.maxX,
                y: toViewFrame.midY)
            
            containerView.addSubview(toVC.view)
            containerView.bringSubviewToFront(toVC.view)
            
            UIView.animate(withDuration: duration) {
                
                toVC.view.center = CGPoint(
                    x: toViewFrame.midX,
                    y: toViewFrame.midY
                )
                
                for subView in fromSubViews {
                    subView.center = CGPoint(
                        x: fromViewFrame.midX - fromViewFrame.maxX,
                        y: subView.frame.midY)
                }
            } completion: { _ in
                toVC.reset()
                transitionContext.completeTransition(true)
            }

        case .pop:
            guard let toVC = transitionContext.viewController(forKey: .to) as? ProgressAnimatable,
                  let fromVC = transitionContext.viewController(forKey: .from) as? ProgressAnimatable else {
                
                transitionContext.completeTransition(true)
                return
            }
            
            let toViewFrame = toVC.view.frame
            let fromViewFrame = fromVC.view.frame
            let toSubViews = toVC.progressingComponents()
            let fromSubView = fromVC.progressingComponents()
            
            toVC.preset()

            for subView in toSubViews {
                subView.center = CGPoint(
                    x: toViewFrame.midX - toViewFrame.maxX,
                    y: subView.frame.midY)
            }
            
            containerView.addSubview(toVC.view)
            
            UIView.animate(withDuration: duration) {

                for subView in toSubViews {
                    subView.center = CGPoint(
                        x: toViewFrame.midX,
                        y: subView.frame.midY)
                }

                for subView in fromSubView {
                    subView.center = CGPoint(
                        x: fromViewFrame.midX + fromViewFrame.maxX,
                        y: subView.frame.midY)
                }
                
            } completion: { _ in
                toVC.reset()
                transitionContext.completeTransition(true)
            }
        default: break
        }
    }
}
