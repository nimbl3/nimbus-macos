//
//  TokenAdapter.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Alamofire

final class TokenAdapter: RequestAdapter {
    
    private let credentialsProvider: CredentialsProvider
    
    init(credentialsProvider: CredentialsProvider) {
        self.credentialsProvider = credentialsProvider
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard
            let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(Paths.baseURL),
            let accessToken = credentialsProvider.credentials?.accessToken
        else { return urlRequest }
        return urlRequest.customizedCopy {
            $0.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
    
}
