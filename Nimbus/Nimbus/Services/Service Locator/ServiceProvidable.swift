//
//  ServiceProvider.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/20/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

protocol ServiceProvider {
    
    func service<T: Service>(of type: T.Type) -> T?
    
}

protocol ServiceProvidable {
    
    var serviceProvider: ServiceProvider { get }
    
}
