//
//  ServiceConfigurator.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/10/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

class ServiceConfigurator {
    
    static func setupRequiredServices(_ serviceLocator: ServiceLocator) {
        let credentialsStorage = CredentialsStorage()
        serviceLocator.registerRequiredService(credentialsStorage)
    }
    
    static func setupServices(_ serviceLocator: ServiceLocator) {
        //todo: - flow
        serviceLocator.clearAllServices(includingRequired: false)
        
        let credentialsStorage = serviceLocator.getService(CredentialsStorage.self)
        let tokenRefresher = TokenRefresher(credentialsProvider: credentialsStorage)
        let tokenAdapter = TokenAdapter(credentialsProvider: credentialsStorage)
        let requestManager = RequestManager(retrier: tokenRefresher, adapter: tokenAdapter)
        serviceLocator.registerService(requestManager)
    }
    
}
