//
//  FlickrFeedInterpreter.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Foundation
import Timepiece
import SwiftyJSON

class FlickrFeedInterpreter: NetworkResponseInterpreter {
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?) -> Response<[FlickrFeedItem], FlickrFeedError> {
        
        guard error == nil, response?.statusCode == 200, let data = data else {
            return Response.error(FlickrFeedError.genericFail)
        }
        
        let json = JSON(data: data)
        
        guard let feedItemsJson = json["items"].array else { return Response.error(FlickrFeedError.genericFail) }
        let events: [FlickrFeedItem] = feedItemsJson.flatMap { innerJson in
            
            guard
                let imageUrlString = innerJson["media"]["m"].string,
                let imageUrl = URL(string: imageUrlString),
                let author = innerJson["author"].string,
                let authorId = innerJson["author_id"].string,
                let published = innerJson["published"].string?.dateInISO8601Format(),
                let dateTaken = innerJson["date_taken"].string?.dateInISO8601Format(),
                let title = innerJson["title"].string,
                let tags = innerJson["tags"].string?.components(separatedBy: " ")
                else { return nil }
            
            return FlickrFeedItem(imageUrl: imageUrl, author: author, authorId: authorId, published: published, dateTaken: dateTaken, title: title, tags: tags)
        }
        
        return Response.success(events)
    }
    
}
