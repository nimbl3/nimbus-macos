//
//  ApplicationRequests.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct Requests {
    
    struct Authentication {
        
        static func login(email: String, password: String) -> Request<Credentials> {
            return Request(
                path: Paths.Authentication.token,
                method: .post,
                parameters: [
                    "grant_type": "braive_password",
                    "email": email,
                    "password": password
                ]
            )
        }
        
        static func revoke(token: String) -> Request<Credentials> { //todo:- update
            return Request(
                path: Paths.Authentication.revoke,
                method: .post,
                parameters:  ["token": token]
            )
        }
        
        static func refreshToken(with refreshToken: String) -> Request<Credentials> {
            return Request(
                path: Paths.Authentication.token,
                method: .post,
                parameters: [
                    "grant_type": "braive_refresh_token",
                    "refresh_token": refreshToken
                ]
            )
        }
        
    }
    
}
