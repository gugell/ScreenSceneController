//
//  ScreenSceneAttachment.swift
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

// MARK: - Attachment Layout (Sizes, Effects, etc)

@objc public class ScreenSceneAttachmentLayout {
    
    public init() {
        
    }
    
    weak var attachment: ScreenSceneAttachment?
    
    public var exclusiveFocus: Bool = ScreenSceneSettings.defaultSettings.attachmentExclusiveFocus {
        didSet { updateAttachemntLayout() }
    }
    
    
    public var portraitWidth: CGFloat = ScreenSceneSettings.defaultSettings.attachmentPortraitWidth {
        didSet { updateAttachemntLayout() }
    }
    
    public var landscapeWidth: CGFloat = ScreenSceneSettings.defaultSettings.attachmentLandscapeWidth {
        didSet { updateAttachemntLayout() }
    }
    
    public var relative: Bool = ScreenSceneSettings.defaultSettings.attachmentRelative {
        didSet { updateAttachemntLayout() }
    }
    
    public var portraitInsets: UIEdgeInsets = UIEdgeInsets(
        top: ScreenSceneSettings.defaultSettings.attachmentTopInset,
        left: ScreenSceneSettings.defaultSettings.attachmentMinLeftInset,
        bottom: ScreenSceneSettings.defaultSettings.attachmentBottomInset,
        right: ScreenSceneSettings.defaultSettings.attachmentMinRightInset) {
        didSet { updateAttachemntLayout() }
    }
    
    public var landscapeInsets: UIEdgeInsets = UIEdgeInsets(
        top: ScreenSceneSettings.defaultSettings.attachmentTopInset,
        left: ScreenSceneSettings.defaultSettings.attachmentMinLeftInset,
        bottom: ScreenSceneSettings.defaultSettings.attachmentBottomInset,
        right: ScreenSceneSettings.defaultSettings.attachmentMinRightInset) {
        didSet { updateAttachemntLayout() }
    }
    
    public var allowInterpolatingEffect: Bool = ScreenSceneSettings.defaultSettings.attachmentAllowInterpolatingEffect {
        didSet { updateAttachemntLayout() }
    }
    
    public var interpolatingEffectRelativeValue: Int = ScreenSceneSettings.defaultSettings.attachmentInterpolatingEffectRelativeValue {
        didSet { updateAttachemntLayout() }
    }
    
    public var shadowIntensity: CGFloat = ScreenSceneSettings.defaultSettings.attachmentShadowIntensity {
        didSet { updateAttachemntLayout() }
    }
    
    public var navigationBarHeight: CGFloat = ScreenSceneSettings.defaultSettings.attachmentNavigationBarHeight {
        didSet { updateAttachemntLayout() }
    }
    
    public var cornerRadius: CGFloat = ScreenSceneSettings.defaultSettings.attachmentCornerRadius {
        didSet { updateAttachemntLayout() }
    }
    
    func updateAttachemntLayout() {
        attachment?.viewController.screenScene?.attachmentLayoutDidChange()
    }
    
}

// MARK: - Attachment

@objc public class ScreenSceneAttachment : NSObject {
    
    public init(viewController: UIViewController) {
        
        self.viewController = viewController
        self.screenSceneAttachmentLayout = ScreenSceneAttachmentLayout()
        
        super.init()
        
        screenSceneAttachmentLayout.attachment = self
        
    }
    
    func performInitialSetups() {
        setupAttachmentNavigationBar(navigationBar, navigationItem: self.viewController.navigationItem)
        setupAttachmentViewControllerView(self.viewController.view)
        setupAttachmentContainerView(self.containerView)
        setupAttachmentContainerOverlay(self.containerOverlay)
    }
    
    func setupAttachmentViewControllerView(view: UIView) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = screenSceneAttachmentLayout.cornerRadius
    }
    
    func setupAttachmentContainerView(view: UIView) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.layer.shadowRadius = self.viewController.view.layer.cornerRadius
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.blackColor().CGColor
        
    }
    
    func setupAttachmentContainerOverlay(view: UIView) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
    }
    
    func setupAttachmentNavigationBar(navigationBar: UINavigationBar, navigationItem: UINavigationItem) {
        
        navigationBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        navigationBar.items = [navigationItem]
        
        let clearColorImage = UIImage.clearImage()
        
        navigationBar.setBackgroundImage(clearColorImage, forBarMetrics: .Default)
        navigationBar.shadowImage = clearColorImage
        
        navigationBar.titleTextAttributes = ScreenSceneSettings.defaultSettings.navigationBarTitleTextAttributes
        
    }
    
    public var screenSceneAttachmentLayout: ScreenSceneAttachmentLayout

    public let viewController: UIViewController

    var interpolatingMotionEffects = [UIInterpolatingMotionEffect]()
    
    var attachInProgress = false
    var detachInProgress = false
    
    var navigationBar = UINavigationBar()
    var containerView = ScreenSceneContainerView()
    var containerOverlay = UIView()
    
}