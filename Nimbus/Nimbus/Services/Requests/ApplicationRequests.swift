//
//  ApplicationRequests.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct Requests {
    
    struct PivotalTracker {
    
        static func login(username: String, password: String) -> Request<Account> {
            var request = Request<Account>(path: Paths.PivotalTracker.me)
            if let credentialsData = "\(username):\(password)"
                .data(using: .utf8)?
                .base64EncodedString() {
                request.headers["Authorization"] = "Basic \(credentialsData)"
            }
            return request
        }
        
    }
    
}
