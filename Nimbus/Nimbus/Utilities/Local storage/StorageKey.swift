//
//  StorageKey.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/17/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

protocol StorageKeys {}

struct StorageKey<T>: StorageKeys {
    
    let name: String
}
