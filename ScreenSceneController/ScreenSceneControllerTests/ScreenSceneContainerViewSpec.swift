//
//  ScreenSceneContainerViewSpec.swift
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
import Quick
import Nimble

class ScreenSceneContainerViewSpec: QuickSpec {
    override func spec() {
        describe("ScreenSceneContainerView") {
            
            var screenSceneContainerView = ScreenSceneContainerView()
            
            describe("when move to .superview") {
                
                it("should have setup like this") {
                    screenSceneContainerView.willMoveToSuperview(nil)
                    expect(screenSceneContainerView.delaysContentTouches).to(beFalsy())
                    expect(screenSceneContainerView.canCancelContentTouches).to(beTruthy())
                    expect(screenSceneContainerView.clipsToBounds).to(beFalsy())
                    expect(screenSceneContainerView.alwaysBounceHorizontal).to(beTruthy())
                    expect(screenSceneContainerView.alwaysBounceVertical).to(beFalsy())
                    expect(screenSceneContainerView.showsHorizontalScrollIndicator).to(beFalsy())
                    expect(screenSceneContainerView.showsVerticalScrollIndicator).to(beFalsy())
                }
                
            }

            describe("when touch intersects .subview") {
                ScreenSceneSettings.defaultSettings.addClassThatDisableScrolling(NSClassFromString("UILabel"))
                
                it("when classesThatDisableScrolling contain view.class should not pass hitTest") {
                    expect(screenSceneContainerView.hitTest(UILabel())).to(beFalsy())
                }
                
                it("when classesThatDisableScrolling contain view.superview.class should not pass hitTest") {
                    
                    let label = UILabel()
                    let imageView = UIImageView()
                    label.addSubview(imageView)
                    
                    expect(screenSceneContainerView.hitTest(imageView)).to(beFalsy())
                }
                
                it("when classesThatDisableScrolling not contain view.class should pass hitTest") {
                    expect(screenSceneContainerView.hitTest(UIImageView())).to(beTruthy())
                }
                
                
            }
            
        }
    }
    
    
}
