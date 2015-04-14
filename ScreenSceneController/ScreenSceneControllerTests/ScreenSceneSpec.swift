//
//  ScreenSceneSpec.swift
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

class ScreenSceneSpec: QuickSpec {

    override func spec() {
        
        describe("ScreenScene") {
            
            var mainController: UIViewController!
            var mainAttachment: ScreenSceneAttachment!
            
            var accessoryController: UIViewController!
            var accessoryAttachment: ScreenSceneAttachment!
            
            var screenScene: MockScreenScene!
            
            beforeEach {
                
                mainController = UIViewController()
                mainAttachment = ScreenSceneAttachment(viewController: mainController)
                
                accessoryController = UIViewController()
                accessoryAttachment = ScreenSceneAttachment(viewController: accessoryController)
                
            }
            
            it("should add attachments when it loaded") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                screenScene.viewDidLoad()
                
                expect(mainAttachment.viewController.parentViewController) === screenScene
                expect(accessoryAttachment.viewController.parentViewController) === screenScene
                
            }
            
            it("should have setup like this when it loaded") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                screenScene.viewDidLoad()
                
                expect(screenScene.edgesForExtendedLayout) == UIRectEdge.None
                expect(screenScene.extendedLayoutIncludesOpaqueBars).to(beTruthy())
                expect(screenScene.automaticallyAdjustsScrollViewInsets).to(beFalsy())
                
                expect(screenScene.sceneTapGestureRecognizer.delegate) === screenScene
                
                expect(screenScene.view.gestureRecognizers).to(contain(screenScene.sceneTapGestureRecognizer))
                
            }
            
            
            
            describe("reactions on view events") {
                
                beforeEach {
                    screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                }
                
                it("viewDidLayoutSubviews") {
                    screenScene.updateShadowsWasCalled = false
                    screenScene.viewDidLayoutSubviews()
                    expect(screenScene.updateShadowsWasCalled).to(beTruthy())
                }
                
                it("willAppear check") {
                    screenScene.updateLayoutWasCalled = false
                    screenScene.viewWillAppear(false)
                    expect(screenScene.updateLayoutWasCalled).to(beTruthy())
                }
                
                it("willRotateToInterfaceOrientation check") {
                    screenScene.updateLayoutWasCalled = false
                    screenScene.updateShadowsWasCalled = false
                    screenScene.willRotateToInterfaceOrientation(screenScene.interfaceOrientation, duration: 0)
                    expect(screenScene.updateLayoutWasCalled).to(beTruthy())
                    expect(screenScene.updateShadowsWasCalled).to(beTruthy())
                }
                
            }
            
            it("should remove attachment before add new one") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                expect(screenScene.accessoryScreenSceneAttachment) === accessoryAttachment
                let allNewAccessoryAttachment = ScreenSceneAttachment(viewController: UIViewController())
                screenScene.attachAccessory(allNewAccessoryAttachment, animated: false)
                expect(screenScene.accessoryScreenSceneAttachment) === allNewAccessoryAttachment
                
            }
            
            it("should setup views hierarchy when add screen scene attachment") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: nil)
                expect(accessoryAttachment.containerView.superview).to(beNil())
                expect(accessoryAttachment.viewController.view.superview).to(beNil())
                expect(accessoryAttachment.containerOverlay.superview).to(beNil())
                
                screenScene.attachAccessory(accessoryAttachment, animated: false)
                
                expect(accessoryAttachment.containerView.superview) === screenScene.view
                expect(accessoryAttachment.viewController.view.superview) === accessoryAttachment.containerView
                expect(accessoryAttachment.navigationBar.superview) === accessoryAttachment.containerView
                expect(accessoryAttachment.containerOverlay.superview) === accessoryAttachment.containerView
            }
            
            it("should remove views owned by attachment when they are disappear") {
                
                screenScene.addScreenSceneAttachment(accessoryAttachment)
                screenScene.removeAllAttachments()
                
                for attachment in screenScene.screenSceneAttachments {
                    for viewOwnedByAttachemnt in [attachment.viewController.view, attachment.containerView, attachment.containerOverlay, attachment.navigationBar] {
                        
                        expect(viewOwnedByAttachemnt.superview).to(beNil())
                    }
                }
                
            }
            
            it("should bring focus on right view") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                screenScene.bringFocus(mainAttachment, animated: false)
                screenScene.updateFocus()
                expect(screenScene.attachmentInFocus(screenScene.accessoryScreenSceneAttachment)).to(beFalsy())
                screenScene.bringFocus(accessoryAttachment, animated: false)
                screenScene.updateFocus()
                expect(screenScene.attachmentInFocus(screenScene.accessoryScreenSceneAttachment)).to(beTruthy())
                screenScene.bringFocus(mainAttachment, animated: false)
                screenScene.updateFocus()
                expect(screenScene.attachmentInFocus(screenScene.accessoryScreenSceneAttachment)).to(beFalsy())
                
                
            }
            
            it("should detach exlusive focus accessory if it lost focus") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                
                accessoryAttachment.screenSceneAttachmentLayout.exclusiveFocus = true
                
                expect(screenScene.attachmentInFocus(screenScene.accessoryScreenSceneAttachment)).to(beTruthy())
                
                screenScene.bringFocus(mainAttachment, animated: false)
                
                expect(screenScene.attachmentInFocus(screenScene.accessoryScreenSceneAttachment)).to(beFalsy())
                
            }
            
            it("currently dragging containerView only can bring focus on itself") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                
                screenScene.scrollViewDidScroll(mainAttachment.containerView)
                expect(screenScene.attachmentInFocus(screenScene.accessoryScreenSceneAttachment)).to(beTruthy())
                
                screenScene.scrollViewDidScroll(mainAttachment.containerView)
                expect(screenScene.attachmentInFocus(mainAttachment)).to(beFalsy())
                screenScene.draggingContainerView = mainAttachment.containerView
                screenScene.scrollViewDidScroll(screenScene.draggingContainerView!)
                expect(screenScene.attachmentInFocus(mainAttachment)).to(beTruthy())
                
                
                screenScene.scrollViewDidScroll(accessoryAttachment.containerView)
                expect(screenScene.attachmentInFocus(accessoryAttachment)).to(beFalsy())
                screenScene.draggingContainerView = accessoryAttachment.containerView
                screenScene.scrollViewDidScroll(screenScene.draggingContainerView!)
                expect(screenScene.attachmentInFocus(accessoryAttachment)).to(beTruthy())
                
            }
            
            it("containersViews should be right ones") {
                
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: nil)
                
                expect(screenScene.containersViews.count).to(equal(1))
                screenScene.attachAccessory(accessoryAttachment, animated: false)
                expect(screenScene.containersViews.count).to(equal(2))
                expect(screenScene.screenSceneAttachmentByContainerView(screenScene.accessoryScreenSceneAttachment!.containerView)) === screenScene.accessoryScreenSceneAttachment
                screenScene.detachAccessory(animated: false)
                expect(screenScene.containersViews.count).to(equal(1))
                expect(screenScene.containersViews).to(contain(mainAttachment.containerView))
                screenScene.removeAllAttachments()
                expect(screenScene.containersViews.count).to(equal(0))
                
            }
            
            it("should have constraints count equal to X when have one attachment") {
                
                let numberOfConstraintsWhenScreenSceneHaveOneAttachment = 20
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: nil)
                
                let containtsBeforeAttachement = screenScene.view.constraints()
                screenScene.attachAccessory(accessoryAttachment, animated: false)
                screenScene.detachAccessory(animated: false)
                expect(screenScene.view.constraints().count).to(beLessThanOrEqualTo(numberOfConstraintsWhenScreenSceneHaveOneAttachment))
            }
            
            it("should have constraints count equal to X when have two attachments") {
                
                let numberOfConstraintsWhenScreenSceneHaveTwoAttachment = 36
                screenScene = MockScreenScene(mainScreenSceneAttachment: mainAttachment, accessoryScreenSceneAttachment: accessoryAttachment)
                expect(screenScene.view.constraints().count).to(beLessThanOrEqualTo(numberOfConstraintsWhenScreenSceneHaveTwoAttachment))
                screenScene.detachAccessory(animated: false)
                screenScene.attachAccessory(accessoryAttachment, animated: false)
                expect(screenScene.view.constraints().count).to(beLessThanOrEqualTo(numberOfConstraintsWhenScreenSceneHaveTwoAttachment))
                
            }
            
            it("should update scene when attachmentLayoutDidChange") {
                
                screenScene.updateMotionEffectsWasCalled = false
                screenScene.updateLayoutWasCalled = false
                screenScene.updateFocusWasCalled = false
                
                screenScene.attachmentLayoutDidChange()
                
                
                expect(screenScene.updateMotionEffectsWasCalled).to(beTruthy())
                expect(screenScene.updateLayoutWasCalled).to(beTruthy())
                expect(screenScene.updateFocusWasCalled).to(beTruthy())
            }
            
        }
        
    }
    
}

class MockScreenScene: ScreenScene {
    
    var viewDidLayoutSubviewsWasCalled = false
    var updateShadowsWasCalled = false
    var updateFocusWasCalled = false
    var updateLayoutWasCalled = false
    var updateMotionEffectsWasCalled = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsWasCalled = true
    }
    
    override func updateShadows(#duration: NSTimeInterval) {
        super.updateShadows(duration: duration)
        updateShadowsWasCalled = true
    }
    
    override func updateFocus() {
        super.updateFocus()
        updateFocusWasCalled = true
    }
    
    override func updateLayout(interfaceOrientation: UIInterfaceOrientation) {
        super.updateLayout(interfaceOrientation)
        updateLayoutWasCalled = true
    }
    
    override func updateMotionEffects(screenSceneAttachment: ScreenSceneAttachment) {
        super.updateMotionEffects(screenSceneAttachment)
        updateMotionEffectsWasCalled = true
    }
}
