//
//  ScreenScene.swift
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

@objc public protocol ScreenSceneDelegate {
    optional func shouldBeginDetachAccessory(screenScene: ScreenScene) -> Bool
    optional func screenScene(screenScene: ScreenScene, willAttachAccessory viewController: UIViewController, animated: Bool)
    optional func screenScene(screenScene: ScreenScene, didAttachAccessory viewController: UIViewController, animated: Bool)
    optional func screenScene(screenScene: ScreenScene, willDetachAccessory viewController: UIViewController, animated: Bool)
    optional func screenScene(screenScene: ScreenScene, didDetachAccessory viewController: UIViewController, animated: Bool)
}

@objc public class ScreenScene: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    // MARK: - Initial Screen Scene Setup
    
    public weak var delegate: ScreenSceneDelegate?
    
    var mainScreenSceneAttachment: ScreenSceneAttachment
    var accessoryScreenSceneAttachment: ScreenSceneAttachment?
    
    var screenSceneAttachments: [ScreenSceneAttachment] {
        var screenSceneAttachments = [mainScreenSceneAttachment]
        if let accessoryScreenSceneAttachment = self.accessoryScreenSceneAttachment {
            screenSceneAttachments.append(accessoryScreenSceneAttachment)
        }
        return screenSceneAttachments
    }
    
    var sceneTapGestureRecognizer = UITapGestureRecognizer()
    
    public init(mainScreenSceneAttachment: ScreenSceneAttachment, accessoryScreenSceneAttachment: ScreenSceneAttachment?) {
        
        self.mainScreenSceneAttachment = mainScreenSceneAttachment
        
        super.init(nibName: nil, bundle: nil)
        self.accessoryScreenSceneAttachment = accessoryScreenSceneAttachment
        
    }
    
    
    public convenience init(mainScreenSceneAttachment: ScreenSceneAttachment) {
        
        self.init(mainScreenSceneAttachment: mainScreenSceneAttachment, accessoryScreenSceneAttachment: nil)
        
    }
    
    public convenience init(mainViewControler: UIViewController, accessoryViewControler: UIViewController?) {
        
        var accessoryScreenSceneAttachment: ScreenSceneAttachment?
        
        if let accessoryViewControler = accessoryViewControler {
            accessoryScreenSceneAttachment = ScreenSceneAttachment(viewController: accessoryViewControler)
        }
        
        self.init(mainScreenSceneAttachment: ScreenSceneAttachment(viewController: mainViewControler), accessoryScreenSceneAttachment: accessoryScreenSceneAttachment)
        
    }
    
    public convenience init(mainViewControler: UIViewController) {
        
        self.init(mainScreenSceneAttachment: ScreenSceneAttachment(viewController: mainViewControler), accessoryScreenSceneAttachment: nil)
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Events
    
    public override func viewDidLoad() {
        
        edgesForExtendedLayout               = .None
        extendedLayoutIncludesOpaqueBars     = true
        automaticallyAdjustsScrollViewInsets = false
        
        attachMain(mainScreenSceneAttachment)
        
        if let _ = accessoryScreenSceneAttachment {
            attachAccessory(accessoryScreenSceneAttachment!, animated: false)
        }
        
        sceneTapGestureRecognizer.delegate = self
        view.addGestureRecognizer(sceneTapGestureRecognizer)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateShadows(duration: 0)
        if accessoryScreenSceneAttachment?.attachInProgress == false &&
            accessoryScreenSceneAttachment?.detachInProgress == false {
                updateOverlays()
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout(interfaceOrientation)
    }
    
    public override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        UIView.animateWithDuration(duration, delay: 0, options: .OverrideInheritedOptions, animations: { [weak self] in
            
            if let weakSelf = self {
                weakSelf.updateLayout(toInterfaceOrientation)
                weakSelf.updateShadows(duration: duration)
                
            } }, completion: { [weak self] (finished: Bool) -> Void in
                
                if let weakSelf = self {
                    weakSelf.updateFocus()
                }
                
        })
    }
    
    // MARK: - Attach and Detach
    
    func addScreenSceneAttachment(screenSceneAttachment: ScreenSceneAttachment) {
        
        removeScreenSceneAttachment(screenSceneAttachment)
        
        screenSceneAttachment.containerView.delegate = self
        view.addSubview(screenSceneAttachment.containerView)
        
        adoptChildViewController(screenSceneAttachment.viewController)
        
        screenSceneAttachment.containerView.addSubview(screenSceneAttachment.viewController.view)
        screenSceneAttachment.containerView.addSubview(screenSceneAttachment.containerOverlay)
        
        screenSceneAttachment.containerView.addSubview(screenSceneAttachment.navigationBar)
        screenSceneAttachment.performInitialSetups()
        
        updateMotionEffects(screenSceneAttachment)
    }
    
    func removeAllAttachments() {
        
        for screenSceneAttachment in screenSceneAttachments {
            removeScreenSceneAttachment(screenSceneAttachment)
        }
        
    }
    
    func removeScreenSceneAttachment(screenSceneAttachment: ScreenSceneAttachment) {
        
        if screenSceneAttachment.viewController.parentViewController != nil {
            screenSceneAttachment.navigationBar.removeFromSuperview()
            screenSceneAttachment.containerView.removeFromSuperview()
            screenSceneAttachment.containerOverlay.removeFromSuperview()
            
            screenSceneAttachment.viewController.leaveParentViewController()
        }
    }
    
    internal func attachMain(mainScreenSceneAttachment: ScreenSceneAttachment) {
        
        mainScreenSceneAttachment.screenSceneAttachmentLayout.exclusiveFocus = false
        
        removeScreenSceneAttachment(mainScreenSceneAttachment)
        
        self.mainScreenSceneAttachment = mainScreenSceneAttachment
        
        addScreenSceneAttachment(mainScreenSceneAttachment)
        
        updateLayout(interfaceOrientation)
        
    }
    
    public func attachAccessory(accessoryScreenSceneAttachment: ScreenSceneAttachment, animated: Bool) {
        
        let completionHandler: (() -> Void) = { [weak self] () in
            
            if let weakSelf = self {
                
                weakSelf.accessoryScreenSceneAttachment = accessoryScreenSceneAttachment
                
                weakSelf.addScreenSceneAttachment(accessoryScreenSceneAttachment)
                
                if animated {
                    weakSelf.pinScreenSceneAttachmentConstraints(accessoryScreenSceneAttachment, interfaceOrientation: weakSelf.interfaceOrientation, containerAttribute: .Left, sceneViewAttribute: .Right)
                    weakSelf.view.layoutIfNeeded()
                    
                }
                
                let animations: (() -> Void) = { () in
                    
                    weakSelf.updateLayout(weakSelf.interfaceOrientation)
                    weakSelf.view.layoutIfNeeded()
                    
                    weakSelf.bringFocus(accessoryScreenSceneAttachment, animated: false)
                }
                
                let animateCompletion: ((Bool) -> Void) = { (finished) in
                    
                    accessoryScreenSceneAttachment.attachInProgress = false
                    weakSelf.delegate?.screenScene?(weakSelf, didAttachAccessory: accessoryScreenSceneAttachment.viewController, animated: animated)
                    weakSelf.bringFocus(accessoryScreenSceneAttachment, animated: false)
                    
                }
                
                if animated {
                    
                    UIView.animateWithDuration(ScreenSceneSettings.defaultSettings.attachAnimationDuration, delay: 0, usingSpringWithDamping: ScreenSceneSettings.defaultSettings.attachAnimationDamping, initialSpringVelocity: 1, options: .CurveEaseIn | .OverrideInheritedOptions, animations: animations, completion: animateCompletion)
                    
                } else {
                    animations()
                    animateCompletion(true)
                }
                
            }
        }
        
        if accessoryScreenSceneAttachment.attachInProgress {
            return
        }
        
        accessoryScreenSceneAttachment.attachInProgress = true
        delegate?.screenScene?(self, willAttachAccessory: accessoryScreenSceneAttachment.viewController, animated: animated)
        
        if let currentScreenSceneAttachment = self.accessoryScreenSceneAttachment {
            
            detachAccessory(animated: animated, completionHandler: completionHandler)
            
        } else {
            
            completionHandler()
            
        }
    }
    
    func detachAccessory(#animated: Bool, completionHandler: (() -> Void)? ) {
        
        if let currentScreenSceneAttachment = self.accessoryScreenSceneAttachment {
            
            if currentScreenSceneAttachment.detachInProgress {
                return
            }
            
            currentScreenSceneAttachment.detachInProgress = true
            delegate?.screenScene?(self, willDetachAccessory: currentScreenSceneAttachment.viewController, animated: animated)
            currentScreenSceneAttachment.viewController.view.endEditing(true)
            
            let animations: (() -> Void) = { [weak self] () in
                if let weakSelf = self {
                    weakSelf.removeScreenSceneAttachmentsContraints()
                    weakSelf.pinScreenSceneAttachmentConstraints(weakSelf.mainScreenSceneAttachment, interfaceOrientation: weakSelf.interfaceOrientation, containerAttribute: .CenterX, sceneViewAttribute: .CenterX)
                    weakSelf.pinScreenSceneAttachmentConstraints(currentScreenSceneAttachment, interfaceOrientation: weakSelf.interfaceOrientation, containerAttribute: .Left, sceneViewAttribute: .Right)
                    
                    weakSelf.view.layoutIfNeeded()
                    
                    weakSelf.bringFocus(weakSelf.mainScreenSceneAttachment, animated: false)
                }
            }
            
            let animateCompletion: ((Bool) -> Void) = { [weak self] (finished) in
                
                if let weakSelf = self {
                    
                    weakSelf.removeScreenSceneAttachment(currentScreenSceneAttachment)
                    weakSelf.accessoryScreenSceneAttachment = nil
                    weakSelf.updateLayout(weakSelf.interfaceOrientation)
                    
                    currentScreenSceneAttachment.detachInProgress = false
                    weakSelf.delegate?.screenScene?(weakSelf, didDetachAccessory: currentScreenSceneAttachment.viewController, animated: animated)
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                    
                }
                
            }
            
            if animated {
                UIView.animateWithDuration(ScreenSceneSettings.defaultSettings.detachAnimationDuration, delay: 0, usingSpringWithDamping: ScreenSceneSettings.defaultSettings.attachAnimationDamping, initialSpringVelocity: 1, options: .CurveEaseIn | .OverrideInheritedOptions, animations: animations, completion: animateCompletion)
            } else {
                animations()
                animateCompletion(true)
            }
            
        }
    }
    
    public func detachAccessory(#animated: Bool) {
        
        detachAccessory(animated: animated, completionHandler: nil)
        
    }
    
    // MARK: - Focus Management
    
    func accessoryExclusiveFocus() -> Bool {
        if let exclusiveFocus = accessoryScreenSceneAttachment?.screenSceneAttachmentLayout.exclusiveFocus {
            return exclusiveFocus
        } else {
            return false
        }
    }
    
    func attachmentInFocus(attachment: ScreenSceneAttachment?) -> Bool {
        if let attachment = attachment {
            return containersViews.last == attachment.containerView && attachment.containerOverlay.alpha == 0
        } else {
            return false
        }
    }
    
    func updateFocus() {
        for attachment in screenSceneAttachments {
            if attachment.containerView == containersViews.last {
                bringFocus(attachment, animated: false)
                break
            }
        }
    }
    
    func bringFocus(attachment: ScreenSceneAttachment?, animated: Bool) {
        
        if var attachment = attachment {
            
            if let accessoryScreenSceneAttachment = self.accessoryScreenSceneAttachment  {
                
                let shouldNotBeginDetachAccessory = accessoryScreenSceneAttachment != attachment &&
                    accessoryScreenSceneAttachment.detachInProgress == false &&
                    delegate?.shouldBeginDetachAccessory?(self) == false
                
                if shouldNotBeginDetachAccessory == true {
                    attachment = accessoryScreenSceneAttachment
                }
                
            }
            
            view.bringSubviewToFront(attachment.containerView)
            
            if accessoryExclusiveFocus() &&
                attachmentInFocus(accessoryScreenSceneAttachment) == false &&
                attachment.attachInProgress == false {
                    detachAccessory(animated: true)
            }
            
            let animations: (() -> Void) = { [weak self] () in
                if let weakSelf = self {
                    weakSelf.updateOverlays()
                }
            }
            
            if animated {
                UIView.animateWithDuration(ScreenSceneSettings.defaultSettings.bringFocusAnimationDuration, delay: 0, options: .OverrideInheritedOptions, animations: animations, completion: nil)
            } else {
                animations()
            }
            
        }
        
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let screenSceneAttachmentByGestureRecognizer = screenSceneAttachmentByGestureRecognizer(gestureRecognizer) {
            bringFocus(screenSceneAttachmentByGestureRecognizer, animated: true)
        }
        
        return false
    }
    
    var draggingContainerView: UIScrollView?
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        draggingContainerView = scrollView
        self.scrollViewDidScroll(scrollView)
        
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        draggingContainerView = nil
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView != draggingContainerView {
            return
        }
        
        for screenSceneAttachment in screenSceneAttachments {
            
            if scrollView == screenSceneAttachment.containerView {
                bringFocus(screenSceneAttachment, animated: true)
                break
            }
            
        }
        
    }
    
    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        if let containerView = accessoryScreenSceneAttachment?.containerView {
            
            var originX: CGFloat = scrollView.bounds.origin.x
            
            if originX < 0 {
                
                originX = fabs(originX)
                
                let width = scrollView.bounds.width
                
                let cap = width * ScreenSceneSettings.defaultSettings.detachCap
                
                if accessoryExclusiveFocus() &&
                    (attachmentInFocus(accessoryScreenSceneAttachment) == false || originX > cap) {
                        bringFocus(mainScreenSceneAttachment, animated: true)
                }
            }
        }
        
    }
    
    var containersViews: [ScreenSceneContainerView] {
        
        var containersViews = [ScreenSceneContainerView]()
        
        for subview in view.subviews as [UIView] {
            
            for screenSceneAttachment in screenSceneAttachments {
                
                if subview == screenSceneAttachment.containerView {
                    containersViews.append(screenSceneAttachment.containerView)
                }
                
            }
        }
        return containersViews
    }
    
    
    func screenSceneAttachmentByContainerView(containerView: ScreenSceneContainerView) -> ScreenSceneAttachment? {
        
        for screenSceneAttachment in screenSceneAttachments {
            
            if screenSceneAttachment.containerView == containerView {
                return screenSceneAttachment
            }
            
        }
        
        return nil
    }
    
    func screenSceneAttachmentByGestureRecognizer(gestureRecognizer: UIGestureRecognizer) -> ScreenSceneAttachment? {
        
        for containerView in containersViews.reverse() {
            
            if containerView.pointInside(gestureRecognizer.locationInView(containerView), withEvent:nil) {
                return screenSceneAttachmentByContainerView(containerView)
            }
            
        }
        
        return nil
    }
    
    // MARK: - Screen Scene Layout and Effects
    
    func updateLayout(interfaceOrientation: UIInterfaceOrientation) {
        
        removeScreenSceneAttachmentsContraints()
        
        if let accessoryScreenSceneAttachment = self.accessoryScreenSceneAttachment {
            
            pinScreenSceneAttachmentConstraints(mainScreenSceneAttachment, interfaceOrientation: interfaceOrientation, containerAttribute: .Left, sceneViewAttribute: .Left)
            pinScreenSceneAttachmentConstraints(accessoryScreenSceneAttachment, interfaceOrientation: interfaceOrientation, containerAttribute: .Right, sceneViewAttribute: .Right)
            
        } else {
            
            pinScreenSceneAttachmentConstraints(mainScreenSceneAttachment, interfaceOrientation: interfaceOrientation, containerAttribute: .CenterX, sceneViewAttribute: .CenterX)
            
        }
        
    }
    
    func updateShadows(#duration: NSTimeInterval) {
        
        for attachment in screenSceneAttachments {
            updateShadow(attachment, duration: duration)
        }
        
    }
    
    func updateShadow(screenSceneAttachment: ScreenSceneAttachment, duration: NSTimeInterval) {
        
        let boundsView = screenSceneAttachment.viewController.view
        let containerView = screenSceneAttachment.containerView
        
        let insets = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? screenSceneAttachment.screenSceneAttachmentLayout.portraitInsets : screenSceneAttachment.screenSceneAttachmentLayout.landscapeInsets
        
        let shadowPath = UIBezierPath()
        let shadowWidth: CGFloat = screenSceneAttachment.screenSceneAttachmentLayout.shadowIntensity
        
        let shadowPoint = CGPoint(x: boundsView.bounds.origin.x, y: boundsView.bounds.origin.x + insets.top)
        let shadowSize = CGSize(width: containerView.frame.size.width, height: containerView.bounds.size.height - insets.bottom)
        
        let shadowBounds = CGRect(origin: shadowPoint, size: shadowSize)
        
        shadowPath.moveToPoint(CGPoint(x: shadowBounds.origin.x, y: shadowBounds.origin.y))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.size.width, y: shadowBounds.origin.y))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.size.width, y: shadowBounds.size.height))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.origin.x, y: shadowBounds.size.height))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.origin.x, y: shadowBounds.origin.y + shadowWidth))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.origin.x + shadowWidth, y: shadowBounds.origin.y + shadowWidth))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.origin.x + shadowWidth, y: shadowBounds.size.height - shadowWidth))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.size.width - shadowWidth, y: shadowBounds.size.height - shadowWidth))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.size.width - shadowWidth, y: shadowBounds.origin.y + shadowWidth))
        shadowPath.addLineToPoint(CGPoint(x: shadowBounds.origin.x, y: shadowBounds.origin.y + shadowWidth))
        
        containerView.layer.shadowPath = shadowPath.CGPath
        screenSceneAttachment.containerOverlay.layer.cornerRadius = screenSceneAttachment.viewController.view.layer.cornerRadius
        
        if duration > 0 {
            let shadowOpacityKey = "shadowOpacity"
            let shadowOpacityAnimation = CAKeyframeAnimation(keyPath: shadowOpacityKey)
            shadowOpacityAnimation.values = [0, 0, containerView.layer.shadowOpacity]
            shadowOpacityAnimation.keyTimes = [0, 0.3, 1]
            shadowOpacityAnimation.duration = duration
            containerView.layer.addAnimation(shadowOpacityAnimation, forKey: shadowOpacityKey)
            
        }
        
    }
    
    var layoutConstaints = [NSLayoutConstraint]()
    
    func pinScreenSceneAttachmentConstraints(screenSceneAttachment: ScreenSceneAttachment, interfaceOrientation: UIInterfaceOrientation, containerAttribute: NSLayoutAttribute, sceneViewAttribute: NSLayoutAttribute) {
        
        if (screenSceneAttachment.containerView.superview != self.view) {
            return
        }
        
        let insets = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? screenSceneAttachment.screenSceneAttachmentLayout.portraitInsets : screenSceneAttachment.screenSceneAttachmentLayout.landscapeInsets
        
        let containerView = screenSceneAttachment.containerView
        
        func layoutConstraintsForNavigationBar() -> [NSLayoutConstraint] {
            
            var layoutConstraintsForNavigationBar = [NSLayoutConstraint]()
            
            if let containerViewSubview = containerView.subviews.first as? UIView {
                
                let navigationBar = screenSceneAttachment.navigationBar
                
                layoutConstraintsForNavigationBar.append(NSLayoutConstraint(item: navigationBar, attribute: .CenterX, relatedBy: .Equal, toItem: containerViewSubview, attribute: .CenterX, multiplier: 1, constant: 0))
                layoutConstraintsForNavigationBar.append(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0))
                layoutConstraintsForNavigationBar.append(NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: containerView, attribute: .Width, multiplier: 1, constant: 0))
                layoutConstraintsForNavigationBar.append(NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: screenSceneAttachment.screenSceneAttachmentLayout.navigationBarHeight))
                
            }
            
            return layoutConstraintsForNavigationBar
        }
        
        func layoutConstraintsForViewControllerView() -> [NSLayoutConstraint] {
            
            var layoutConstraintsForViewControllerView = [NSLayoutConstraint]()
            
            for attribute in [NSLayoutAttribute.Width, NSLayoutAttribute.Height, NSLayoutAttribute.CenterX, NSLayoutAttribute.Top] {
                
                let constraint = NSLayoutConstraint(item: screenSceneAttachment.viewController.view,
                    attribute: attribute, relatedBy: .Equal, toItem: containerView, attribute: attribute, multiplier: 1, constant: 0)
                
                if attribute == NSLayoutAttribute.Height {
                    
                    constraint.constant -= insets.top
                    constraint.constant -= insets.bottom
                    
                } else if attribute == NSLayoutAttribute.Top {
                    
                    constraint.constant += insets.top
                    
                }
                
                layoutConstraintsForViewControllerView.append(constraint)
            }
            
            return layoutConstraintsForViewControllerView
        }
        
        func layoutConstraintsForContainerView() -> [NSLayoutConstraint] {
            
            var layoutConstraintsForContainerView = [NSLayoutConstraint]()
            
            var alignContraint: NSLayoutConstraint
            
            if containerAttribute == .Left {
                alignContraint = NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .GreaterThanOrEqual, toItem: self.view, attribute: sceneViewAttribute, multiplier: 1, constant: insets.left)
            } else if containerAttribute == .Right {
                alignContraint = NSLayoutConstraint(item: self.view, attribute: sceneViewAttribute, relatedBy: .GreaterThanOrEqual, toItem: containerView, attribute: .Right, multiplier: 1, constant: insets.right)
            } else {
                alignContraint = NSLayoutConstraint(item: containerView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: sceneViewAttribute, multiplier: 1, constant: 0)
            }
            
            alignContraint.priority = 750
            
            layoutConstraintsForContainerView.append(alignContraint)
            
            layoutConstraintsForContainerView.append(NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
            layoutConstraintsForContainerView.append(NSLayoutConstraint(item: containerView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
            
            
            let width = UIInterfaceOrientationIsLandscape(interfaceOrientation) ? screenSceneAttachment.screenSceneAttachmentLayout.landscapeWidth : screenSceneAttachment.screenSceneAttachmentLayout.portraitWidth
            
            if screenSceneAttachment.screenSceneAttachmentLayout.relative {
                layoutConstraintsForContainerView.append(NSLayoutConstraint(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: width, constant: 0))
            } else {
                layoutConstraintsForContainerView.append(NSLayoutConstraint(item: containerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width))
            }
            
            return layoutConstraintsForContainerView
        }
        
        func layoutConstraintsForContainerOverlay() -> [NSLayoutConstraint] {
            return screenSceneAttachment.containerOverlay.scaleToFillContraints(forView: screenSceneAttachment.viewController.view)
        }
        
        layoutConstaints += layoutConstraintsForNavigationBar()
        layoutConstaints += layoutConstraintsForViewControllerView()
        layoutConstaints += layoutConstraintsForContainerView()
        layoutConstaints += layoutConstraintsForContainerOverlay()
        
        view.addConstraints(layoutConstaints)
        
    }
    
    func updateMotionEffects(screenSceneAttachment: ScreenSceneAttachment) {
        var motionViews = [UIView]()
        
        motionViews.append(screenSceneAttachment.viewController.view)
        motionViews.append(screenSceneAttachment.navigationBar)
        
        for motionView in motionViews {
            for oldEffect in screenSceneAttachment.interpolatingMotionEffects {
                motionView.removeMotionEffect(oldEffect)
            }
        }
        
        screenSceneAttachment.interpolatingMotionEffects.removeAll()
        
        if screenSceneAttachment.screenSceneAttachmentLayout.allowInterpolatingEffect {
            for motionView in motionViews {
                let xEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
                
                xEffect.minimumRelativeValue = -screenSceneAttachment.screenSceneAttachmentLayout.interpolatingEffectRelativeValue
                xEffect.maximumRelativeValue = screenSceneAttachment.screenSceneAttachmentLayout.interpolatingEffectRelativeValue
                
                screenSceneAttachment.interpolatingMotionEffects.append(xEffect)
                motionView.addMotionEffect(xEffect)
            }
        }
        
    }
    
    func updateOverlays() {
        
        var rectIntersectsRect = false
        
        let mainView = mainScreenSceneAttachment.containerView
        
        if let accessoryView = accessoryScreenSceneAttachment?.containerView {
            let mainBounds = mainView.convertRect(mainView.bounds, toView: view)
            let accessoryBounds = accessoryView.convertRect(accessoryView.bounds, toView: view)
            rectIntersectsRect = CGRectIntersectsRect(mainBounds, accessoryBounds)
        }
        
        let accessoryExclusiveFocus = self.accessoryExclusiveFocus()
        
        let containerViews = containersViews
        
        if rectIntersectsRect ||
            accessoryExclusiveFocus {
                
                for containerView in containerViews {
                    
                    if let screenSceneAttachment = screenSceneAttachmentByContainerView(containerView) {
                        screenSceneAttachment.containerOverlay.bringSubviewToFront(containerView)
                        screenSceneAttachment.containerOverlay.alpha = containerView == containerViews.last ? 0 : 1
                    }
                }
                
        } else {
            for screenSceneAttachment in screenSceneAttachments {
                screenSceneAttachment.containerOverlay.alpha = 0
            }
        }
        
        
    }
    
    
    func removeScreenSceneAttachmentsContraints() {
        
        self.view.removeConstraints(layoutConstaints)
        layoutConstaints.removeAll()
    }
    
    
    func attachmentLayoutDidChange() {
        
        for screenSceneAttachment in screenSceneAttachments {
            updateMotionEffects(screenSceneAttachment)
        }
        
        updateLayout(interfaceOrientation)
        updateFocus()
        
    }
    
}
