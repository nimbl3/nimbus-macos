//
//  CredentialsStorage.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/18/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

protocol CredentialsProvider: class {
    
    var credentials: Credentials? { get }
    
    func acceptNewCredentials(_ credentials: Credentials)
}

final class CredentialsStorage: Service, CredentialsProvider {
    
    private let keychain = Keychain()
    
    private(set) lazy var credentials: Credentials? = {
        guard
            let data = keychain[data: .credentials],
            let credentials = try? JSONDecoder().decode(Credentials.self, from: data)
        else { return nil }
        return credentials
    }()
    
    var isAuthenticated: Bool {
        return credentials != nil
    }
    
    // MARK: - credentials provider
    
    func acceptNewCredentials(_ credentials: Credentials) {
        try? save(credentials)
    }
    
    // MARK: - helpers
    
    func remove() throws {
        do {
            try keychain.remove(.credentials)
            credentials = nil
        } catch { throw Errors.Authentication.unableToRemoveToken }
    }
    
    private func save(_ credentials: Credentials) throws {
        do {
            self.credentials = credentials
            try keychain.set(JSONEncoder().encode(credentials), key: .credentials)
        } catch { throw Errors.Authentication.unableToSaveToken }
    }
    
}
