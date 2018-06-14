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
            urlString.hasPrefix(Paths.PivotalTracker.baseUrl),
            let accessToken = credentialsProvider.credentials?.accessToken
        else { return urlRequest }
        var request = urlRequest
        request.setValue("\(accessToken)", forHTTPHeaderField: "X-TrackerToken")
        return request
    }
    
}
