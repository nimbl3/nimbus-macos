//
//  HotkeyManager.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/15/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa
import HotKey

final class HotkeyManager {
    
    private let copyHotkey = HotKey(key: .c, modifiers: [.command, .shift])
    
    func configureCopyHotkey(for story: Story, withNotification: Bool = true) {
        copyHotkey.keyDownHandler = { [weak self] in
            self?.copyToPasteboard("\(story.id)")
            self?.notify(with: story)
        }
    }
    
    // MARK: - private helper
    
    private func copyToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private func notify(with story: Story) {
        let notification = NSUserNotification()
        notification.title = story.name
        notification.informativeText = "The story's ID has been copied to your clipboard"
        NSUserNotificationCenter.default.deliver(notification)
    }
}

final class CopyManager {
    
    private let pasteboard = NSPasteboard.general
    
    func copyToPasteboard(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
}

final class NotificationManager {
    
    private let notificationCenter = NSUserNotificationCenter.default
    
    func notify(title: String? = nil, text: String? = nil) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = text
        notificationCenter.deliver(notification)
    }
}
