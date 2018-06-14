//
//  Keychain.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import KeychainAccess

class Keychain {
    
    enum Key: String {
        
        case credentials
        case user
        
    }
    
    private let keychain = KeychainAccess.Keychain(server: Paths.baseURL, protocolType: .https)
    
    subscript(_ key: Key) -> String? {
        get { return keychain[key.rawValue] }
        set { keychain[key.rawValue] = newValue }
    }
    
    subscript(data key: Key) -> Data? {
        get { return keychain[data: key.rawValue] }
        set { keychain[data: key.rawValue] = newValue }
    }
    
    func remove(_ key: Key) throws {
        try keychain.remove(key.rawValue)
    }
    
    func set(_ data: Data, key: Key) throws {
        try keychain.set(data, key: key.rawValue)
    }
    
    func set(_ text: String, key: Key) throws {
        try keychain.set(text, key: key.rawValue)
    }
    
}
