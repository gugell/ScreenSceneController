//
//  ScreenSceneControllerExtensions.swift
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

extension UIView {
    
    public func scaleToFillContraints(forView view: UIView) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        for attribute in [NSLayoutAttribute.Width, NSLayoutAttribute.Height, NSLayoutAttribute.CenterX, NSLayoutAttribute.CenterY] {
            constraints.append(NSLayoutConstraint(item: self,
                attribute: attribute, relatedBy: .Equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0))
        }
        return constraints

    }
    
}

extension UIViewController {
    
    public var screenSceneController: ScreenSceneController? {
        
        if let screenSceneController = parentViewController as? ScreenSceneController {
            return screenSceneController
        } else if let screenSceneController = parentViewController?.screenSceneController {
            return screenSceneController
        }
        return nil
    }
    
    public var screenScene: ScreenScene? {
        
        if let scenes = screenSceneController?.viewControllers {
            for scene in  scenes {
                for child in scene.childViewControllers as! [UIViewController] {
                    if self == child {
                        return scene
                    }
                }
            }
        }
        
        return nil
    }
    
    func adoptChildViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
        childViewController.didMoveToParentViewController(self)
    }
    
    func leaveParentViewController() {
        willMoveToParentViewController(nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
    
}

extension UIImage {
    class func clearImage() -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, rect)
        
        let clearColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clearColorImage
        
    }
}


