//
//  ApplicationFlowController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa
import ReactiveSwift
import Result
import HotKey

class ApplicationFlowController {
    
    private let credentialsStorage = CredentialsStorage()
    private let manager: RequestManager
    
    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .transient
        return popover
    }()
    
    // MARK: - menu items
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private let fetchMenuItem = NSMenuItem(title: "Fetch", action: nil, keyEquivalent: "F")
    
    private let projectsMenuItem = NSMenuItem(title: "Select project", action: nil, keyEquivalent: "")
    
    private let accountMenuItem = NSMenuItem(title: "Account", action: nil, keyEquivalent: "")
    private var quitMenuItem = NSMenuItem(title: "Quit",
                                          action: #selector(NSApplication.terminate),
                                          keyEquivalent: "q")
    init() {
        let adapter = TokenAdapter(credentialsProvider: credentialsStorage)
        manager = RequestManager(adapter: adapter)
    }
    
    lazy var storyHotkey: HotKey = { HotKey(key: .c, modifiers: [.command, .shift]) }()
    
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
    
    @objc private func showLogin() {
        guard let button = statusItem.button else { return }
        let controller = LoginViewController.from(storyboard: .main)
        controller.onSignInWithCredentials = signIn
        popover.contentViewController = controller
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    // MARK: - networking
    
    private func signIn(username: String, password: String) {
        let request = Requests.PivotalTracker.login(username: username, password: password)
        
        manager.perform(request)
            .startWithResult { [weak self] result in
                switch result {
                case .success(let account):
                    self?.saveCredentials(account.apiToken)
                    self?.updateMenu(with: account)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
    
    
    
    // MARK: - private helper
    
    private func saveCredentials(_ accessToken: String) {
        credentialsStorage.acceptNewCredentials(Credentials(accessToken: accessToken))
    }
    
    private func fetchStories(of project: Project) {
        let request = Requests.PivotalTracker.stories(ofProjectId: project.projectId,
                                                      withState: .started)
        manager.perform(request)
            .startWithResult { [weak self] result in
                switch result {
                case .success(let stories):
                    self?.stories = stories
                    self?.updateStoriesMenu(of: project, with: stories)
                case .failure(let error):
                    debugPrint("### error", error)
                }
        }
    }
    
    private let projectTitleMenuItem = NSMenuItem(title: "No project selected", action: nil, keyEquivalent: "")
    private var selectedStoryItem: NSMenuItem?
    
    
    private func updateStoriesMenu(of project: Project, with stories: [Story]) {
        guard
            let menu = statusItem.menu,
            let index = menu.items.index(of: projectTitleMenuItem)
        else { return }
        projectTitleMenuItem.title = project.projectName
        stories.enumerated().forEach {
            let item = createItem(title: $1.name, action: #selector(focusStory))
            menu.insertItem(item, at: (index + 1) + $0)
        }
    }
    
    @objc private func focusStory(_ item: NSMenuItem) {
        guard let story = stories.first(where: { $0.name == item.title }) else { return }

        selectedStory = story
        selectedStoryItem?.state = .off
        selectedStoryItem = item
        
        item.state = .on
        storyHotkey.keyDownHandler = {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString("\(story.id)", forType: .string)
            
            let notification = NSUserNotification()
            notification.title = story.name
            notification.informativeText = "The story's ID has been copied to your clipboard"
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
    
    private func updateMenu(with account: Account) {
        guard let menu = statusItem.menu else { return }
        menu.removeAllItems()
        
        menu.insertItem(fetchMenuItem, at: 0)
        
        menu.addItem(projectsMenuItem)
        configureProjectsMenu(with: account.projects)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(projectTitleMenuItem)
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(accountMenuItem)
        menu.addItem(quitMenuItem)
    }
    
    // MARK: - private configuration
    
    private var stories: [Story] = []
    private var selectedStory: Story?
    
    private var projects: [Project] = []
    private var selectedProject: Project? {
        didSet {
            guard let project = selectedProject else { return }
            fetchStories(of: project)
        }
    }
    
    private func configureProjectsMenu(with projects: [Project]) {
        let menu = NSMenu()
        self.projects = projects
        projects.forEach {
            let item = createItem(title: $0.projectName, action: #selector(selectProject))
            menu.addItem(item)
        }
        projectsMenuItem.submenu = menu
    }
    
    @objc private func selectProject(_ item: NSMenuItem) {
        projectsMenuItem.submenu?.items.enumerated()
            .forEach {
                $1.state = .off
                if $1 == item { selectedProject = projects[$0] }
            }
        item.state = .on
    }
    
    private func createItem(title: String, action: Selector?, key: String = "") -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: key)
        item.target = self
        return item
    }

}
