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
            
            toVC.preset()
            toVC.setInitStateAsTo()
            
            containerView.addSubview(toVC.view)
            containerView.bringSubviewToFront(toVC.view)
            
            UIView.animate(withDuration: duration) {
                toVC.setFinalStateAsTo()
                fromVC.setFinalStateAsFrom()
            } completion: { _ in
                toVC.reset()
                transitionContext.completeTransition(true)
            }

        case .pop: break
        default: break
        }
    }
}
