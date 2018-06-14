//
//  NSViewController+StoryboardInstantiable.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

protocol StoryboardInstantiable {}

extension NSViewController: StoryboardInstantiable {}

extension StoryboardInstantiable where Self: NSViewController {
    
    private static var identifier: NSStoryboard.SceneIdentifier {
        return NSStoryboard.SceneIdentifier(rawValue: "\(self)")
    }
    
    static func from(storyboard storyboardName: NSStoryboard.Name) -> Self {
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        guard
            let controller = storyboard.instantiateController(withIdentifier: identifier) as? Self
            else { fatalError("Cannot find \(identifier) in \(storyboardName)") }
        return controller
    }
    
}

extension NSStoryboard.Name {
    
    static var main: NSStoryboard.Name {
        return NSStoryboard.Name(rawValue: "Main")
    }
    
}
