//
//  ProjectController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/15/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

class ProjectController: MenuController {
    
    private let manager: RequestManager
    
    private let projectsItem = NSMenuItem(title: "Select project", action: nil, keyEquivalent: "")
    private let submenu = NSMenu()
    
    private let projects: [Project] = []
    
    private var selectedProjectItem: NSMenuItem? {
        didSet { selectedProject = projects.first { $0.projectName == selectedProjectItem?.title } }
    }
    
    private(set) var selectedProject: Project? {
        didSet {
            guard let project = selectedProject else { return }
            onSelectProject?(project)
        }
    }
    
    var onSelectProject: ((Project) -> Void)?
    
    init(with requestManager: RequestManager) {
        manager = requestManager
        projectsItem.submenu = submenu
    }
    
    // MARK: - menu controller
    
    var items: [NSMenuItem] {
        return [projectsItem]
    }
    
    func configure(with projects: [Project]) {
        submenu.removeAllItems()
        
        projects.forEach {
            let item = createItem(title: $0.projectName, action: #selector(selectProject))
            submenu.addItem(item)
        }
    }
    
    // MARK: - action
    
    @objc private func selectProject(_ item: NSMenuItem) {
        item.state = .on
        selectedProjectItem?.state = .off
        selectedProjectItem = item
    }
    
    // MARK: - privete helper
    
    
    
}
