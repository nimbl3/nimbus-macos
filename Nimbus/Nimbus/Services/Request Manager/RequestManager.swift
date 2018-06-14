//
//  RequestManager.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import ReactiveSwift
import Result
import Alamofire

class RequestManager: Service {
    
    private let alamofire: SessionManager
    
    init(retrier: RequestRetrier? = nil, adapter: RequestAdapter? = nil) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        alamofire = SessionManager(configuration: configuration)
        alamofire.retrier = retrier
        alamofire.adapter = adapter
    }
    
    func perform<T>(_ request: Request<T>) -> SignalProducer<T, Errors.Network> {
        return perform(request,
                       for: T.self,
                       responseHandler: .default(format: request.jsonFormat))
    }
    
    func perform<T>(_ request: CollectionRequest<T>) -> SignalProducer<[T], Errors.Network> {
        return perform(request,
                       for: [T].self,
                       responseHandler: .default(format: request.jsonFormat))
    }
    
    // MARK: - private request performing
    
    private func perform<T: Decodable>(_ request: APIRequestable,
                                       for type: T.Type,
                                       responseHandler: AnyResponseHandlable<T>) -> SignalProducer<T, Errors.Network> {
        return SignalProducer { [weak self] observer, lifetime in
            guard let strongSelf = self else { return observer.sendInterrupted() }
            
            let task = strongSelf.alamofire
                .request(request.path,
                         method: request.method,
                         parameters: request.parameters,
                         encoding: request.encoding,
                         headers: request.headers)
                .validate(strongSelf.validateUnauthorizedRequest)
                .responseData { responseHandler.handleResponse($0, with: observer) }
                .task
            lifetime.observeEnded {
                observer.sendInterrupted()
                task?.cancel()
            }
        }
    }
    
    // MARK: - private helper
    
    private func validateUnauthorizedRequest(request: URLRequest?,
                                             response: HTTPURLResponse,
                                             data: Data?) -> DataRequest.ValidationResult {
        return response.statusCode != 401 ? .success : .failure(Errors.Network.unauthorized)
    }
    
}
