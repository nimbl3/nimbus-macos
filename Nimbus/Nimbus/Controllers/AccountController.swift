//
//  AccountController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/15/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

protocol MenuController: AnyObject {
    
    var items: [NSMenuItem] { get }
    
}

extension MenuController {
    
    func createItem(title: String, action: Selector?, key: String = "") -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: key)
        item.target = self
        return item
    }
    
}

final class AccountMenuController: MenuController {
    
    private let provider: CredentialsProvider
    private let manager: RequestManager
    
    private let accountItem = NSMenuItem(title: "Account", action: nil, keyEquivalent: "")
    
    private let loginViewController = LoginViewController.from(storyboard: .main)
    private let applicationButton: NSButton //todo:- remove
    
    var onSignIn: ((Account) -> Void)?
    var onSignOut: CompletionHandler?
    
    
    
    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .transient
        return popover
    }()
    
    init(with requestManager: RequestManager,
         credentialsProvider: CredentialsProvider,
         applicationButton: NSButton) {
        manager = requestManager
        provider = credentialsProvider
        self.applicationButton = applicationButton
    }
    
    // MARK: - menu controller
    
    var items: [NSMenuItem] {
        return [accountItem]
    }
    
    func configure() {
        let menu = accountItem.submenu ?? NSMenu()
        menu.removeAllItems()
        
        //todo: - support logged-in state
        menu.addItem(createItem(title: "Sign in", action: #selector(showLogin)))
        
        accountItem.submenu = menu
    }
    
    // MARK: - action
    
    @objc private func showLogin() {
        loginViewController.onSignInWithCredentials = signIn
        popover.contentViewController = loginViewController
        popover.show(relativeTo: applicationButton.bounds, of: applicationButton, preferredEdge: .minY)
    }
    
    @objc private func logout() {
        onSignOut?()
    }
    
    // MARK: - private helper
    
    private func signIn(username: String, password: String) {
        let request = Requests.PivotalTracker.login(username: username, password: password)
        
        manager.perform(request)
            .startWithResult { [weak self] result in
                switch result {
                case .success(let account):
                    self?.saveCredentials(account.apiToken)
                    self?.onSignIn?(account)
                case .failure(let error):
                    debugPrint(error)
                }
        }
    }
    
    private func saveCredentials(_ accessToken: String) {
        provider.acceptNewCredentials(Credentials(accessToken: accessToken))
    }
    
}
