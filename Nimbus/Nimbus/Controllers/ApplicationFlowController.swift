//
//  ApplicationFlowController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

class ApplicationFlowController {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func start() {
        setupIcon()
        setupMenu()
    }
    
    // MARK: - private setup
    
    private func setupIcon() {
        guard let button = statusItem.button else { return }
        button.image = #imageLiteral(resourceName: "icon.post-it")
        button.action = #selector(click)
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        menu.addItem(createMenuItem(title: "First", action: #selector(printSomething), key: "1"))
        menu.addItem(createMenuItem(title: "Second", action: #selector(printSomething), key: "2"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "q"))
        
        
        statusItem.menu = menu
    }
    
    // MARK: - action
    
    @objc private func click() {
        print("### click")
    }
    
    @objc private func printSomething(_ sender: NSMenuItem) {
        print("### item: \(sender.title)")
    }
    
    // MARK: - private helper
    
    private func createMenuItem(title: String, action: Selector, key: String) -> NSMenuItem {
        let menuItem = NSMenuItem(title: title, action: action, keyEquivalent: key)
        menuItem.target = self
        return menuItem
    }
    
}
