//
//  ApplicationErrors.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct Errors {
    
    enum Authentication: LocalizedError {
        
        case unableToSaveToken
        case unableToRemoveToken
        
    }
    
    enum Network: LocalizedError {
        
        case unauthorized
        case invalidResponse(Error)
        
        case general(underlying: Error)
        
    }
    
}
