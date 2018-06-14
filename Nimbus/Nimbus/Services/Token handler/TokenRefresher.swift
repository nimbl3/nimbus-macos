//
//  TokenRefresher.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Alamofire

private enum RefreshResult {
    
    case success(Credentials)
    case failure
    
    var isSucceeded: Bool {
        if case .success = self { return true }
        return false
    }
    
}

private typealias RefreshCompletion = (RefreshResult) -> Void

final class TokenRefresher: RequestRetrier {
    
    private let sessionManager = SessionManager()
    
    private let credentialsProvider: CredentialsProvider
    private let lock = NSLock()
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    init(credentialsProvider: CredentialsProvider) {
        self.credentialsProvider = credentialsProvider
    }
    
    func should(_ manager: SessionManager,
                retry request: Alamofire.Request,
                with error: Error,
                completion: @escaping RequestRetryCompletion) {
        lock.lock()
        defer { lock.unlock() }
        
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            let refreshToken = credentialsProvider.credentials?.refreshToken
        else { return completion(false, 0.0) }
        
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            tryRefreshToken(with: refreshToken) { [weak self] result in
                guard let refresher = self else { return }
                refresher.lock.lock()
                defer { refresher.lock.unlock() }
                
                if case .success(let credentials) = result {
                    refresher.save(credentials)
                }
                
                refresher.requestsToRetry.forEach { $0(result.isSucceeded, 0.0) }
                refresher.requestsToRetry.removeAll()
            }
        }
    }
    
    private func tryRefreshToken(with refreshToken: String,
                                 completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        let request = Requests.Authentication.refreshToken(with: refreshToken)
        
        sessionManager
            .request(request.path,
                     method: request.method,
                     parameters: request.parameters,
                     encoding: request.encoding)
            .responseData { [weak self] response in
                guard let refresher = self else { return }
                refresher.isRefreshing = false
                guard
                    let data = response.data,
                    let credentials = try? JSONDecoder().decode(Credentials.self, from: data)
                else { return completion(.failure) }
                completion(.success(credentials))
            }
    }
    
    private func save(_ credentials: Credentials) {
        credentialsProvider.acceptNewCredentials(credentials)
    }
    
}
