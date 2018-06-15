//
//  ApplicationFlowController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa
import ReactiveSwift

class ApplicationFlowController {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private let accountMenuItem: NSMenuItem
    private var quitMenuItem: NSMenuItem
    
    private let credentialsStorage = CredentialsStorage()
    private let manager: RequestManager
    
    init() {
        accountMenuItem = NSMenuItem(title: "Account", action: nil, keyEquivalent: "")
        quitMenuItem = NSMenuItem(title: "Quit",
                                  action: #selector(NSApplication.terminate),
                                  keyEquivalent: "q")
        let adapter = TokenAdapter(credentialsProvider: credentialsStorage)
        manager = RequestManager(adapter: adapter)
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
        guard let button = statusItem.button else { return }
        let controller = LoginViewController.from(storyboard: .main)
        controller.onSignInWithCredentials = signIn
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = controller
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    private func signIn(username: String, password: String) {
        let request = Requests.PivotalTracker.login(username: username, password: password)
        
        manager.perform(request)
            .startWithResult {
                switch $0 {
                case .success(let account):     print("### \(account)")
                case .failure(let error):       debugPrint(error)
                }
            }
    }
    
    // MARK: - private helper
    
    private func createItem(title: String, action: Selector?, key: String = "") -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: key)
        item.target = self
        return item
    }

}
