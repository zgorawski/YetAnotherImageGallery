//
//  NetworkingEngine.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Alamofire

typealias IsRequestValid = Bool

class NetworkingEngine {
    
    // MARK: API
    
    @discardableResult
    open func performRequest<Req: NetworkRequest>(request: Req, handler: @escaping (Response<Req.InterpreterType.SuccessType, Req.InterpreterType.ErrorType>) -> Void ) -> IsRequestValid  {
        
        guard let url = computeURL(request) else { return false }
        
        let afRequest = Alamofire.request(url, method: request.httpMethod, parameters: request.parameters, encoding: request.parameterEncoding, headers: request.headers)
        
        afRequest.responseData { response in
            
            let interpretedResponse = request.interpreter.interpret(data: response.data, response: response.response, error: response.error)
            
            DispatchQueue.main.async { handler(interpretedResponse) }
        }
        
        return true
    }
    
    fileprivate func computeURL<Req: NetworkRequest>(_ request: Req) -> URL? {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = request.host
        urlComponents.path = request.endpoint
        
        return urlComponents.url
    }
}

