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
    
    private let accountMenuItem: NSMenuItem
    private var quitMenuItem: NSMenuItem
    
    init() {
        accountMenuItem = NSMenuItem(title: "Account", action: nil, keyEquivalent: "")
        quitMenuItem = NSMenuItem(title: "Quit",
                                  action: #selector(NSApplication.terminate),
                                  keyEquivalent: "q")
    }
    
    func start() {
        setupIcon()
        setupMenu()
        setupAccountMenu()
    }
    
    // MARK: - private setup
    
    private func setupIcon() {
        guard let button = statusItem.button else { return }
        button.image = #imageLiteral(resourceName: "icon.post-it")
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        menu.addItem(accountMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitMenuItem)
        
        statusItem.menu = menu
    }
    
    private func setupAccountMenu() {
        let menu = NSMenu()
        
        menu.addItem(createItem(title: "Sign in", action: #selector(showLogin)))
        
        accountMenuItem.submenu = menu
    }
    
    // MARK: - action
    
    @objc private func printSomething(_ sender: NSMenuItem) {
        print("### item: \(sender.title)")
    }
    
    @objc private func showLogin() {
        let controller = LoginViewController.from(storyboard: .main)
        let panel = NSPanel()
        panel.contentViewController = controller
        panel.backgroundColor = .red
        panel.display()
    }
    
    // MARK: - private helper
    
    private func createItem(title: String, action: Selector?, key: String = "") -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: key)
        item.target = self
        return item
    }

}
