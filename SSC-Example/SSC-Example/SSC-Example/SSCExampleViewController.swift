//
//  ViewController.swift
//  SSC-Example
//
//  Created by Ruslan Shevchuk on 01/11/14.
//  Copyright (c) 2014 Ruslan Shevchuk. All rights reserved.
//

import ScreenSceneController

class SSCExampleViewController: ScreenSceneController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushNewScreneScene()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.pushNewScreneScene()
        })

    }
    
    func pushNewScreneScene() {
        let testViewController = UITableViewController()
        testViewController.view.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
        let testViewControllerWidth = AttachmentWidth(width: 535/1024, relative: true)
        let mainAttachment = Attachment(viewController: testViewController, viewControllerWidth: testViewControllerWidth)
        let sceneScene = ScreenScene(mainAttachment:mainAttachment , accessoryAttachment: nil)
        pushSceneScene(sceneScene, animated: true)
    }

}

