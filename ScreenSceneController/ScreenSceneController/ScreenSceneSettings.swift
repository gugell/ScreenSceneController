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
    
    var classesThatDisableScrolling = [AnyClass]()
    func addClassThatDisableScrolling(classThatDisableScrolling: AnyClass) {
        classesThatDisableScrolling.append(classThatDisableScrolling)
    }
    
    var navigationBarTitleTextAttributes: [String: AnyObject] =
    [
        NSFontAttributeName: UIFont.boldSystemFontOfSize(20),
        NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    
    var bringFocusAnimationDuration: NSTimeInterval    = 0.15
    
    var attachAnimationDamping: CGFloat                = 0.8
    var attachAnimationDuration: NSTimeInterval        = 0.4
    
    var detachAnimationDuration: NSTimeInterval        = 0.3
    
    var detachCap: CGFloat                             = 0.1
    
    var attachmentAllowInterpolatingEffect: Bool       = true
    var attachmentInterpolatingEffectRelativeValue:Int = 20

    var attachmentCornerRadius: CGFloat                = 10

    var attachmentPortraitWidth: CGFloat               = 0.5
    var attachmentLandscapeWidth: CGFloat              = 0.5
    var attachmentRelative: Bool                       = true
    var attachmentExclusiveFocus: Bool                 = false
    
    var attachmentTopInset: CGFloat                    = 65
    var attachmentBottomInset: CGFloat                 = 20
    var attachmentMinLeftInset: CGFloat                = 10
    var attachmentMinRightInset: CGFloat               = 10

    var attachmentNavigationBarHeight:CGFloat          = 65

    var attachmentShadowIntensity:CGFloat              = 4
    
}
