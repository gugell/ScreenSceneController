//
//  ScreenSceneController.swift
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

@objc public protocol ScreenSceneControllerDelegate {
    optional func screenSceneController(screenSceneController: ScreenSceneController, willShowViewController viewController: UIViewController, animated: Bool)
    optional func screenSceneController(screenSceneController: ScreenSceneController, didShowViewController viewController: UIViewController, animated: Bool)
}

@objc public class ScreenSceneController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Initial Screen Scene Controller Setup
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChildScreenSceneNavigationController()
    }
    
    lazy var screenSceneNavigationController : UINavigationController = {
        let screenSceneNavigationController = UINavigationController()
        screenSceneNavigationController.delegate = self
        screenSceneNavigationController.navigationBarHidden = true
        return screenSceneNavigationController
        }()
    
    func addChildScreenSceneNavigationController() {
        
        adoptChildViewController(screenSceneNavigationController)
        
        screenSceneNavigationController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.insertSubview(screenSceneNavigationController.view, atIndex: 0)
        view.addConstraints(screenSceneNavigationController.view.scaleToFillContraints(forView: view))
        
    }
    
    // MARK: - Screen Scene Navigation Controller Transition Effect
    
    var transitionEffect = ScreenSceneControllerTransition()
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation != .None {
            transitionEffect.navigationControllerOperation = operation
            return transitionEffect
        } else {
            return nil
        }
    }
    
    // MARK: - Screen Scene Navigation Delegate
    
    public weak var delegate: ScreenSceneControllerDelegate?
    
    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        delegate?.screenSceneController?(self, willShowViewController: viewController, animated: animated)
    }
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        delegate?.screenSceneController?(self, didShowViewController: viewController, animated: animated)
        
    }
    
    // MARK: - Scene Managment
    
    public var topViewController: ScreenScene? {
        get {
            if let topViewController = screenSceneNavigationController.topViewController as? ScreenScene {
                return topViewController
            }
            return nil
        }
    }
    
    public var viewControllers: [ScreenScene] {
        get {
            return screenSceneNavigationController.viewControllers as! [ScreenScene]
        }
        set {
            setViewControllers(newValue, animated: false)
        }
    }
    
    public func setViewControllers(viewControllers: [AnyObject]!, animated: Bool) {
        screenSceneNavigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    // MARK: - Push
    
    public func pushScreenScene(screenScene: ScreenScene, animated: Bool) {
        screenSceneNavigationController.pushViewController(screenScene, animated: animated)
    }
    
    // MARK: - Pops
    
    public func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        return screenSceneNavigationController.popViewControllerAnimated(animated)
    }
    
    public func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]? {
        return screenSceneNavigationController.popToViewController(viewController, animated: animated)
    }
    
    public func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
        return screenSceneNavigationController.popToRootViewControllerAnimated(animated)
    }
    
}
 