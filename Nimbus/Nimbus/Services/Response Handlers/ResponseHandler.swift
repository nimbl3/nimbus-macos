//
//  ResponseHandler.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 5/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import Alamofire

class ResponseHandler<ObjectType: Decodable>: ResponseHandlable {
    
    let jsonFormat: JSONFormatType
    
    typealias ResponseType = ObjectType
    
    init(format: JSONFormatType) {
        jsonFormat = format
    }
    
    func handleResponse(_ response: DataResponse<Data>, with observer: ResponseObserver) {
        switch response.result {
        case .success(let data):
            do {
                let result = try decode(ResponseType.self, from: data, format: jsonFormat)
                observer.send(value: result)
                observer.sendCompleted()
            } catch {
                observer.send(error: .invalidResponse(error))
            }
        case .failure(let error):
            observer.send(error: .general(underlying: error))
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data, format: JSONFormatType) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
    
}
