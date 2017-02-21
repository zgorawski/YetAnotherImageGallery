//
//  FlickrFeedController.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Foundation

class FlickrFeedController {
    
    // injectable dependencies
    fileprivate let networkingEngine: NetworkingEngineProtocol
    
    init(networkingEngine: NetworkingEngineProtocol = NetworkingEngine()) {
        self.networkingEngine = networkingEngine
    }
    
    // MARK: API
    
    func fetchFeed(handler: @escaping (Response<[FlickrFeedItem], FlickrFeedError>) -> Void) {
        
        let request = FlickrFeedRequest()
        networkingEngine.performRequest(request: request, handler: handler)
    }
}
