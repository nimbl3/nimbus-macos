//
//  NSMenuItem+Creational.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/17/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Cocoa

extension NSMenuItem {
    
    convenience init(title: String, key: String = "") {
        self.init(title: title, action: nil, keyEquivalent: key)
    }
    
}
