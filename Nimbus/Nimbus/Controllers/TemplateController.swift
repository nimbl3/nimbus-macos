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
    
    private let titleItem = NSMenuItem(title: "Template")
    private let addItem = NSMenuItem(title: "Add template...")
    
    private var templateItems: [NSMenuItem] = []
    
    private var templates: [String: Template] = [:] {
        didSet { update(with: templates) }
    }
    
    var onUpdateTemplates: (([Template]) -> Void)?
    
    init() {}
    
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
        print("### \(template.name): \(template.content)")
    }
    
    private func fetchTemplates() {
        templates = storage.get(.templates) ?? [:]
        print("### Templates", templates)
    }
    
    private func saveTemplate(name: String, _ content: String) {
        templates[name] = Template(name: name, content: content)
        try? storage.save(templates, key: .templates)
    }
    
}
