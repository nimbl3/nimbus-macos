//
//  Credentials.swift
//  Nimbus
//
//  Created by Pirush Prechathavanich on 6/14/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Foundation

struct Credentials: Codable, Equatable {
    
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: TimeInterval
    let createdAt: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case createdAt = "created_at"
    }
    
}
