//
//  ApplicationController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa
import ReactiveSwift
import Result
import HotKey

final class ApplicationController {
    
    private let credentialsStorage = CredentialsStorage()
    private let manager: RequestManager
    
    // MARK: - controllers
    
    private let accountController: AccountMenuController
    private let projectController: ProjectController
    private let storiesController: StoriesController
    
    private let hotkeyManager = HotkeyManager()
    
    // MARK: - menu items
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private let fetchMenuItem = NSMenuItem(title: "Fetch", action: nil, keyEquivalent: "F")
    private var quitMenuItem = NSMenuItem(
        title: "Quit",
        action: #selector(NSApplication.terminate),
        keyEquivalent: "q"
    )
    
    init() {
        let adapter = TokenAdapter(credentialsProvider: credentialsStorage)
        manager = RequestManager(adapter: adapter)
        statusItem.menu = NSMenu()
        accountController = AccountMenuController(with: manager,
                                                  credentialsProvider: credentialsStorage,
                                                  applicationButton: statusItem.button!)
        projectController = ProjectController(with: manager)
        storiesController = StoriesController(with: manager)
    }
    
    lazy var storyHotkey: HotKey = { HotKey(key: .c, modifiers: [.command, .shift]) }()
    
    func start() {
        setupIcon()
        setupMenu(with: nil)
    }
    
    // MARK: - private setup
    
    private func setupIcon() {
        guard let button = statusItem.button else { return }
        button.image = #imageLiteral(resourceName: "icon.post-it")
    }
    
    private func setupMenu(with account: Account?) {
        guard let menu = statusItem.menu else { return }
        menu.removeAllItems()
        
        if let account = account {
            projectController.configure(with: account.projects)
            projectController.items.forEach(menu.addItem)
            projectController.onSelectProject = { [weak self] project in
                self?.storiesController.configure(with: project)
            }
            
            menu.addItem(.separator())
            
            storiesController.items.forEach(menu.addItem)
            storiesController.onUpdateStories = { [weak self] _ in
                self?.setupMenu(with: account)
            }
            storiesController.onSelectStory = { [weak self] story in
                self?.hotkeyManager.configureCopyHotkey(for: story)
            }
            
            menu.addItem(.separator())
        }
        
        accountController.configure()
        accountController.items.forEach(menu.addItem)
        accountController.onSignIn = { [weak self] account in
            self?.setupMenu(with: account)
        }
        
        menu.addItem(quitMenuItem)
    }
    
}
