//
//  FlickrFeedRequest.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct FlickrFeedRequest: NetworkRequest {
    
    var httpMethod: HTTPMethod { return .get }
    var host: String { return "api.flickr.com" }
    var endpoint: String { return "/services/feeds/photos_public.gne" }
    
    var parameters: Parameters? { return ["format": "json", "nojsoncallback": 1] }
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    var headers: HTTPHeaders? { return nil }
    
    let interpreter: FlickrFeedInterpreter = FlickrFeedInterpreter()
}

class FlickrFeedInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?) -> Response<[FlickrFeedItem], FlickrFeedError> {
        
        guard error == nil, response?.statusCode == 200, let data = data else {
            return Response.error(FlickrFeedError.genericFail)
        }
        
        let json = JSON(data: data)
        let events: [FlickrFeedItem] = []
        
        print(json)
        
        return Response.success(events)
    }
    
}
