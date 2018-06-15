//
//  Account.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/15/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

struct Account: Codable {
    
    let id: Int
    let name: String
    let username: String
    let apiToken: String
    
    let projects: [Project]
    
}
