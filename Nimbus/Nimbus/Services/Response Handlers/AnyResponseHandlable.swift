//
//  AnyResponseHandlable.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 5/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Alamofire

extension AnyResponseHandlable {
    
    static func `default`<T: Decodable>(format: JSONFormatType) -> AnyResponseHandlable<T> {
        return AnyResponseHandlable<T>(ResponseHandler(format: format))
    }
    
    static var metaOnly: AnyResponseHandlable<JSON> {
        return AnyResponseHandlable<JSON>(MetaResponseHandler())
    }
}

class AnyResponseHandlable<T: Decodable>: ResponseHandlable {
    
    typealias ResponseType = T
    
    private let _handleResponse: (_ response: DataResponse<Data>, _ observer: ResponseObserver) -> Void
    
    init<U: ResponseHandlable>(_ handler: U) where T == U.ResponseType {
        _handleResponse = handler.handleResponse
    }
    
    func handleResponse(_ response: DataResponse<Data>, with observer: ResponseObserver) {
        _handleResponse(response, observer)
    }
    
}
