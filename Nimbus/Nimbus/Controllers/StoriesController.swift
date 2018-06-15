//
//  StoriesController.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/15/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa
import ReactiveSwift

final class StoriesController: MenuController {
    
    private let manager: RequestManager
    private var disposable: Disposable?
    
    private let projectItem = NSMenuItem(title: "No project selected", action: nil, keyEquivalent: "")
    private let helpItem = NSMenuItem(
        title: "- Select a story and use CMD + SHIFT + C.",
        action: nil,
        keyEquivalent: ""
    )
    private var storyItems: [NSMenuItem] = []
    
    private(set) var stories: [Story] = [] {
        didSet { update(with: stories) }
    }
    
    // MARK: - selected properties
    
    private var selectedStoryItem: NSMenuItem? {
        didSet { selectedStory = stories.first { $0.name == selectedStoryItem?.title } }
    }
    
    private(set) var selectedStory: Story? {
        didSet {
            guard let story = selectedStory else { return }
            onSelectStory?(story)
        }
    }
    
    var onUpdateStories: (([Story]) -> Void)?
    var onSelectStory: ((Story) -> Void)?
    
    init(with requestManager: RequestManager) {
        manager = requestManager
    }
    
    // MARK: - menu controller
    
    var items: [NSMenuItem] {
        var items = [projectItem]
        if !storyItems.isEmpty { items.append(helpItem) }
        items.append(contentsOf: storyItems)
        return items
    }
    
    func configure(with project: Project) {
        projectItem.title = project.projectName
        fetchStories(of: project)
    }
    
    private func fetchStories(of project: Project) {
        let request = Requests.PivotalTracker.stories(ofProjectId: project.projectId,
                                                      withState: .started)
        disposable?.dispose()
        disposable = manager.perform(request)
            .startWithResult { [weak self] result in
                switch result {
                case .success(let stories):     self?.stories = stories
                case .failure(let error):       debugPrint(error)
                }
        }
    }
    
    private func update(with stories: [Story]) {
        storyItems = stories.map {
            let item = createItem(title: $0.name, action: #selector(selectStory))
            item.representedObject = $0
            if $0.id == selectedStory?.id { item.state = .on }
            return item
        }
        onUpdateStories?(stories)
    }
    
    // MARK: - action
    
    @objc private func selectStory(_ item: NSMenuItem) {
        item.state = .on
        selectedStoryItem?.state = .off
        selectedStoryItem = item
    }
    
}
