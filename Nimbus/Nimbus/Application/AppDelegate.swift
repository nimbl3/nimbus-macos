//
//  AppDelegate.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupIcon()
        setupMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: - private helper
    
    private func setupIcon() {
        guard let button = statusItem.button else { return }
        button.image = #imageLiteral(resourceName: "icon.post-it")
        button.action = #selector(click)
    }

    private func setupMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "First", action: #selector(printSomething), keyEquivalent: "1"))
        menu.addItem(NSMenuItem(title: "Second", action: #selector(printSomething), keyEquivalent: "2"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc private func click() {
        print("### click")
    }
    
    @objc private func printSomething(_ sender: NSMenuItem) {
        print("### item: \(sender.title)")
    }

}

