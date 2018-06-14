//
//  APIRequestable.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/21/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Alamofire

enum JSONFormatType {
    case plain, jsonAPI
}

protocol APIRequestable {
    
    var path: String { get set }
    var method: HTTPMethod { get set }
    var parameters: [String: Any]? { get set }
    var headers: [String: String] { get set }
    var encoding: ParameterEncoding { get set }
    
    var jsonFormat: JSONFormatType { get }
    
}
