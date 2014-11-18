//
//  ScreenSceneContainerView.swift
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

@objc public class ScreenSceneContainerView: UIScrollView {
    
    // MARK: - Initial Screen Container Setup
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        alwaysBounceHorizontal         = true
        alwaysBounceVertical           = false
        canCancelContentTouches        = true
        clipsToBounds                  = false

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator   = false

        delaysContentTouches           = false
    }
    
    // MARK: -
    // Possibility to disable scroll when container touch intersect some special view that not allow containers moves during interaction with it.

    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        if let view = super.hitTest(point, withEvent: event) {
            
            let scrollEnabled = hitTest(view)
            self.scrollEnabled = scrollEnabled
            
            return view
        } else {
            return nil
        }
    }
    
    func hitTest(view: UIView) -> Bool {
        
        var enableScroll = true
        for anyClass in ScreenSceneSettings.defaultSettings.classesThatDisableScrolling {
            
            if shouldDisableScroll(view, classToCheck: anyClass) {
                enableScroll = false
                break
            }
            
        }
        
        return enableScroll
    }
    
    func shouldDisableScroll(view: UIView, classToCheck: AnyClass) -> Bool {
        
        if (view.isKindOfClass(classToCheck)) {
            return true
        } else if let superview = view.superview {
            return shouldDisableScroll(superview, classToCheck: classToCheck)
        } else {
            return false
        }
    }
}
