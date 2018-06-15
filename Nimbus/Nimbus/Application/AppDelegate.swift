//
//  AppDelegate.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var applicationController: ApplicationController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        applicationController = ApplicationController()
        applicationController.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

