//
//  TemplateController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/17/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

final class TemplateController: MenuController {
    
    private let storage = LocalStorage()
    private let copyManager: CopyManager
    private let notificationManager: NotificationManager
    
    private let titleItem = NSMenuItem(title: "Template")
    private let addItem = NSMenuItem(title: "Add template...")
    
    private var templateItems: [NSMenuItem] = []
    
    private var templates: [String: Template] = [:] {
        didSet { update(with: templates) }
    }
    
    var onUpdateTemplates: (([Template]) -> Void)?
    
    init(with copyManager: CopyManager, and notificationManager: NotificationManager) {
        self.copyManager = copyManager
        self.notificationManager = notificationManager
    }
    
    // MARK: - menu controller
    
    var items: [NSMenuItem] {
        var items = [titleItem]
        items.append(contentsOf: templateItems)
        items.append(addItem)
        return items
    }
    
    func configure() {
        fetchTemplates()
    }
    
    // MARK: - private helper
    
    private func update(with templates: [String: Template]) {
        templateItems = templates.values.map {
            let item = createItem(title: $0.name, action: #selector(copyTemplate))
            item.representedObject = $0
            return item
        }
    }
    
    @objc private func copyTemplate(_ item: NSMenuItem) {
        guard let template = item.representedObject as? Template else { return }
        copyManager.copyToPasteboard(template.content)
        notificationManager.notify(
            title: template.name,
            text: "The template's content has been copied to your clipboard"
        )
    }
    
    private func fetchTemplates() {
        var templates = storage.get(.templates) ?? [:]
        //todo:- remove
        templates["PR template"] = Template(
            name: "PR template",
            content: """
            https://www.pivotaltracker.com/story/show/
            
            ### **What Happened**
            
            Some detail goes here...
            
            ### **Insight**
            
            Some detail goes here...
            
            ### **Proof of Work**
            
            ![alt text](https://link.com)
            """
        )
        
        self.templates = templates
    }
    
    private func saveTemplate(name: String, _ content: String) {
        templates[name] = Template(name: name, content: content)
        try? storage.save(templates, key: .templates)
    }
    
}
