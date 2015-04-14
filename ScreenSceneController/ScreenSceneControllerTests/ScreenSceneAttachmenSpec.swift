//
//  ScreenSceneAttachmenSpec.swift
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

class ScreenSceneAttachmenSpec: QuickSpec {
    override func spec() {
        
        describe("ScreenSceneAttachment") {
            
            var screenSceneAttachment: MockScreenSceneAttachment!
            
            beforeEach {
                screenSceneAttachment = MockScreenSceneAttachment(viewController: UIViewController())
            }
            
            it("should setup navigationBar when it newly created") {
                expect(screenSceneAttachment.setupAttachmentNavigationBarWasCalled).to(beFalsy())
                screenSceneAttachment.performInitialSetups()
                expect(screenSceneAttachment.setupAttachmentNavigationBarWasCalled).to(beTruthy())
            }
            
            it("should setup viewController.view when it newly created") {
                expect(screenSceneAttachment.setupAttachmentViewControllerViewWasCalled).to(beFalsy())
                screenSceneAttachment.performInitialSetups()
                expect(screenSceneAttachment.setupAttachmentViewControllerViewWasCalled).to(beTruthy())
            }
            
            it("should setup attachment.containerView when it newly created") {
                expect(screenSceneAttachment.setupAttachmentContainerOverlayWasCalled).to(beFalsy())
                screenSceneAttachment.performInitialSetups()
                expect(screenSceneAttachment.setupAttachmentContainerOverlayWasCalled).to(beTruthy())
            }
            
            it("should setup attachment.containerOverlay when it newly created") {
                expect(screenSceneAttachment.setupAttachmentContainerOverlayWasCalled).to(beFalsy())
                screenSceneAttachment.performInitialSetups()
                expect(screenSceneAttachment.setupAttachmentContainerOverlayWasCalled).to(beTruthy())
            }
            
        }
        
        describe("ScreenSceneAttachmentLayout") {
            
            
            var screenSceneAttachmentLayout: MockScreenSceneAttachmentLayout!
            
            beforeEach {
                screenSceneAttachmentLayout = MockScreenSceneAttachmentLayout()
            }
             
            context("should perform updateAttachemntLayout() when didSet some var") {
                it("exclusiveFocus") {
                    screenSceneAttachmentLayout.exclusiveFocus = false
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
                it("portraitWidth") {
                    screenSceneAttachmentLayout.portraitWidth = 100
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
                it("landscapeWidth") {
                    screenSceneAttachmentLayout.landscapeWidth = 100
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
                it("relative") {
                    screenSceneAttachmentLayout.relative = false
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
                it("insets") {
                    screenSceneAttachmentLayout.portraitInsets = UIEdgeInsetsZero
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                    screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled = false
                    screenSceneAttachmentLayout.landscapeInsets = UIEdgeInsetsZero
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
                it("interpolatingEffectRelativeValue") {
                    screenSceneAttachmentLayout.interpolatingEffectRelativeValue = 100
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
                it("shadowIntensity") {
                    screenSceneAttachmentLayout.shadowIntensity = 100
                    expect(screenSceneAttachmentLayout.updateAttachemntLayoutWasCalled).to(beTruthy())
                }
            }
            
            it("should have portraitWidth == landscapeWidth when init(width: ...") {
                
                screenSceneAttachmentLayout = MockScreenSceneAttachmentLayout()
                
                expect(screenSceneAttachmentLayout.landscapeWidth).to(equal(screenSceneAttachmentLayout.portraitWidth))
                
                expect(screenSceneAttachmentLayout.relative).to(equal(true))
                
            }
            
        }
        
        
    }
}

class MockScreenSceneAttachment : ScreenSceneAttachment {
    var setupAttachmentNavigationBarWasCalled = false
    var setupAttachmentViewControllerViewWasCalled = false
    var setupAttachmentContainerViewWasCalled = false
    var setupAttachmentContainerOverlayWasCalled = false
    
    override func setupAttachmentNavigationBar(navigationBar: UINavigationBar, navigationItem: UINavigationItem) {
        super.setupAttachmentNavigationBar(navigationBar, navigationItem: navigationItem)
        setupAttachmentNavigationBarWasCalled = true
    }
    
    override func setupAttachmentViewControllerView(view: UIView) {
        super.setupAttachmentViewControllerView(view)
        setupAttachmentViewControllerViewWasCalled = true
    }
    
    override func setupAttachmentContainerView(view: UIView) {
        super.setupAttachmentContainerView(view)
        setupAttachmentContainerViewWasCalled = true
    }
    
    override func setupAttachmentContainerOverlay(view: UIView) {
        super.setupAttachmentContainerOverlay(view)
        setupAttachmentContainerOverlayWasCalled = true
    }
}

class MockScreenSceneAttachmentLayout : ScreenSceneAttachmentLayout {
    var updateAttachemntLayoutWasCalled = false
    override func updateAttachemntLayout() {
        super.updateAttachemntLayout()
        updateAttachemntLayoutWasCalled = true
    }
}
