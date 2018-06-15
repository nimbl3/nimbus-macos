//
//  Story.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/15/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

struct Story: Codable {
    
    enum State: String, Codable {
        
        case accepted
        case delivered
        case finished
        case started
        case rejected
        case planned
        case unstarted
        case unscheduled
        
    }
    
    let id: Int
    let name: String
    
    
}
