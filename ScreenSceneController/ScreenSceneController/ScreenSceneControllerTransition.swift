//
//  ScreenSceneControllerTransition.swift
//  ScreenSceneController
//
// Copyright (c) 2014 Ruslan Shevchuk
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class ScreenSceneControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionDuration: NSTimeInterval                             = 0.65
    var transitionAnimationDamping: CGFloat                            = 0.82

    var navigationControllerOperation: UINavigationControllerOperation = .None
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        
        if let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view {
            if let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view {
                
                let containerView = transitionContext.containerView()
                containerView.insertSubview(toView, belowSubview: fromView)
                
                var screenFrame = fromView.frame
                
                var toStartX: CGFloat = 0
                var fromEndX: CGFloat = 0
                
                if navigationControllerOperation == .Push {
                    toStartX = screenFrame.size.width
                    fromEndX = -screenFrame.size.width
                } else {
                    toStartX = -screenFrame.size.width
                    fromEndX = screenFrame.size.width
                }
                
                toView.frame = CGRectOffset(screenFrame, toStartX, 0)
                
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: transitionAnimationDamping, initialSpringVelocity: 1, options: .CurveEaseInOut, animations: { () -> Void in
                    fromView.frame = CGRectOffset(screenFrame, fromEndX, 0)
                    toView.frame = screenFrame
                }, completion: { (Bool finished) -> Void in
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }
    
}
