//
//  ScreenSceneSettings.swift
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

@objc (ScreenSceneSettings)
public class ScreenSceneSettings {
    
    private struct Static {
        static let instance = ScreenSceneSettings()
    }
    
    public class var defaultSettings : ScreenSceneSettings {
        return Static.instance
    }
    
    public var classesThatDisableScrolling = [AnyClass]()
    public func addClassThatDisableScrolling(classThatDisableScrolling: AnyClass) {
        classesThatDisableScrolling.append(classThatDisableScrolling)
    }
    
    public var navigationBarTitleTextAttributes: [String: AnyObject] =
    [
        NSFontAttributeName: UIFont.boldSystemFontOfSize(20),
        NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    
    public var bringFocusAnimationDuration: NSTimeInterval    = 0.15
    
    public var attachAnimationDamping: CGFloat                = 0.8
    public var attachAnimationDuration: NSTimeInterval        = 0.4
    
    public var detachAnimationDuration: NSTimeInterval        = 0.3
    
    public var detachCap: CGFloat                             = 0.1
    
    public var attachmentAllowInterpolatingEffect: Bool       = true
    public var attachmentInterpolatingEffectRelativeValue:Int = 20

    public var attachmentCornerRadius: CGFloat                = 10

    public var attachmentPortraitWidth: CGFloat               = 0.5
    public var attachmentLandscapeWidth: CGFloat              = 0.5
    public var attachmentRelative: Bool                       = true
    public var attachmentExclusiveFocus: Bool                 = false
    
    public var attachmentTopInset: CGFloat                    = 65
    public var attachmentBottomInset: CGFloat                 = 20
    public var attachmentMinLeftInset: CGFloat                = 10
    public var attachmentMinRightInset: CGFloat               = 10

    public var attachmentNavigationBarHeight:CGFloat          = 65

    public var attachmentShadowIntensity:CGFloat              = 4
    
}
