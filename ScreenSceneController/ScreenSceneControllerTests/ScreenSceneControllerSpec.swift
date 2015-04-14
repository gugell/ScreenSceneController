//
//  ScreenSceneControllerSpec.swift
//  ScreenSceneControllerSpec
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

var willShowViewController: UIViewController?
var didShowViewController: UIViewController?

class ScreenSceneControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("ScreenSceneController") {
            var screenSceneController: ScreenSceneController!
            
            describe("when it loaded") {
                
                beforeEach {
                    screenSceneController = ScreenSceneController()
                    screenSceneController.viewDidLoad()
                }
                                
                it("should preserve subviews order and place them on top of screenSceneNavigationCcontroller") {
                    var orderedSubviewsAddedBeforeChildNavigationController = [UIImageView(), UIButton(), UILabel()]
                    
                    for subviewToAdd in orderedSubviewsAddedBeforeChildNavigationController {
                        screenSceneController.view.addSubview(subviewToAdd)
                    }
                    
                    let orderedSubviewsAddedAfterChildNavigationController = screenSceneController.view.subviews as! [UIView]
                    
                    orderedSubviewsAddedBeforeChildNavigationController.insert(screenSceneController.screenSceneNavigationController.view, atIndex: 0)
                    expect(orderedSubviewsAddedBeforeChildNavigationController).to(equal(orderedSubviewsAddedAfterChildNavigationController))
                    
                }
                
                it("should add child screenSceneNavigationController when perform initial setup") {
                    expect(screenSceneController.childViewControllers).to(contain(screenSceneController.screenSceneNavigationController))
                }
                
            }
            
        }
        
        describe("UIViewController inside ScreenSceneController") {

            var viewController: UIViewController!
            var secondScreenScene: ScreenScene!
            var firstSceneController: ScreenScene!
            var screenSceneController: ScreenSceneController!
            beforeEach {

                viewController = UIViewController()
                
                firstSceneController = ScreenScene(mainScreenSceneAttachment: ScreenSceneAttachment(viewController: UIViewController()), accessoryScreenSceneAttachment: nil)
                
                secondScreenScene = ScreenScene(mainScreenSceneAttachment: ScreenSceneAttachment(viewController: viewController), accessoryScreenSceneAttachment: nil)
                
                screenSceneController = ScreenSceneController()
                screenSceneController.viewDidLoad()
                
                screenSceneController.pushScreenScene(firstSceneController, animated: false)
                
                firstSceneController.viewDidLoad()
            }
            
            describe("when UIViewController not have screenSceneController") {
                
                it("UIViewController should return nil ScreenSceneController") {
                    
                    expect(secondScreenScene.screenSceneController).to(beNil())
                    expect(viewController.screenSceneController).to(beNil())
                    
                }
            }
            
            
            describe("when UIViewController have a screenSceneController") {
                
                it("UIViewController should return screenScene and screenSceneController") {
                    
                    screenSceneController.pushScreenScene(secondScreenScene, animated: false)
                    secondScreenScene.viewDidLoad()
                    
                    expect(viewController.screenSceneController).to(equal(screenSceneController))
                    expect(secondScreenScene.screenSceneController).to(equal(screenSceneController))
                    expect(viewController.screenScene).to(equal(secondScreenScene))
                    
                    
                }
                
                
                it("ScreenSceneController should have right viewControllers count and topViewController when setViewControllers") {
                    screenSceneController.setViewControllers([firstSceneController], animated: false)
                    expect(screenSceneController.topViewController).to(equal(firstSceneController))
                    expect(screenSceneController.viewControllers.count).to(equal(1))
                    screenSceneController.setViewControllers([firstSceneController, secondScreenScene], animated: false)
                    expect(screenSceneController.viewControllers.count).to(equal(2))
                    expect(screenSceneController.topViewController).to(equal(secondScreenScene))
                    
                }
            }
            
        }
        
    }
    
}
