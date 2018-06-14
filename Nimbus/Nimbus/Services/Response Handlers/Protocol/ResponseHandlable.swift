//
//  ResponseHandlable.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 5/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import ReactiveSwift
import Alamofire

protocol ResponseHandlable {
    
    typealias ResponseObserver = Signal<ResponseType, Errors.Network>.Observer
    
    associatedtype ResponseType: Decodable
    
    func handleResponse(_ response: DataResponse<Data>, with observer: ResponseObserver)
    
}
