//
//  Animator.swift
//  ZwischMe2
//
//  Created by Edward Bender on 12/8/15.
//  Copyright © 2015 Edward Bender. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        transitionContext.containerView()?.addSubview((toVC?.view)!)
        toVC?.view.alpha = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            toVC?.view.alpha = 1.0
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }

}
