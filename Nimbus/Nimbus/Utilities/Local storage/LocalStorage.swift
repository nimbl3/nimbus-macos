//
//  LocalStorage.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/17/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

final class LocalStorage {
    
    private let fileManager = FileManager.default
    
    func get<T: Decodable>(_ key: StorageKey<T>) -> T? {
        guard
            let data = fileManager.contents(atPath: key.name),
            let content = try? PropertyListDecoder().decode(T.self, from: data)
            else { return nil }
        return content
    }
    
    func save<T: Encodable>(_ value: T, key: StorageKey<T>) throws {
        let data = try PropertyListEncoder().encode(value)
        try data.write(to: URL(fileURLWithPath: key.name))
    }
    
    func remove<T>(key: StorageKey<T>) throws {
        try fileManager.removeItem(atPath: key.name)
    }
    
}
