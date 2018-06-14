//
//  CollectionRequest.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/21/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Alamofire

///
/// A detail struct for *RequestManager* to perform a request with external API.
/// The expected response type is a collection of the input `T`.
///
/// Note that this struct should have the exact same behaviour as Request.
/// except for the expected response type.
///

struct CollectionRequest<T: Decodable>: APIRequestable {
    
    typealias ResponseType = [T]
    
    var path: String
    var method: HTTPMethod
    var parameters: [String: Any]?
    var headers: [String: String] = [:]
    var encoding: ParameterEncoding
    
    let jsonFormat: JSONFormatType
    
    /// - parameters:
    ///     - path: absolute url path of the request
    ///     - method: http method of the request. default is `.get`
    ///     - parameters: parameters of the request. keep in mind that, for
    ///       *JSON:API* format request, parameters should be in its own format.
    ///       default is `nil`
    ///     - headers: headers of the request. if `jsonFormat` is set to `.jsonAPI`,
    ///       `Content-Type` will be set to `application/vnd.api+json` by default.
    ///       default is an empty dictionary.
    ///     - format: json format of the request. default is `.jsonAPI`
    init(path: String,
         method: HTTPMethod = .get,
         parameters: [String: Any]? = nil,
         headers: [String: String] = [:],
         encoding: ParameterEncoding = JSONEncoding.default,
         format: JSONFormatType = .jsonAPI) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
        self.jsonFormat = format
        
        if case .jsonAPI = format {
            self.headers["Content-Type"] = "application/vnd.api+json"
        }
    }
    
}
