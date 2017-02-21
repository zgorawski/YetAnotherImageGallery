//
//  RequestProtocol.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    
    var httpMethod: HTTPMethod{ get }
    var host: String { get }
    var endpoint: String { get }
    
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
    
    associatedtype InterpreterType: NetworkResponseInterpreter
    var interpreter: InterpreterType { get }
}
