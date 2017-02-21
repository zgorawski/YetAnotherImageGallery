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
                let rawAuthor = innerJson["author"].string,
                let authorId = innerJson["author_id"].string,
                let published = innerJson["published"].string?.dateInISO8601Format(),
                let dateTaken = innerJson["date_taken"].string?.dateInISO8601Format(),
                let title = innerJson["title"].string,
                let tags = innerJson["tags"].string?.components(separatedBy: " ")
                else { return nil }
            
            // further data processing
            let author = extractAuthor(rawAuthor: rawAuthor)
            
            return FlickrFeedItem(imageUrl: imageUrl, author: author, authorId: authorId, published: published, dateTaken: dateTaken, title: title, tags: tags)
        }
        
        return Response.success(events)
    }
    
    //
    // many authors in data from flickr happens to be in form:
    // "nobody@flickr.com ("REAL_AUTHOR")"
    // this method extracts inner author, if able or return parameter string
    //
    // TODO: consider promoting regexp method to String extension
    //
    fileprivate func extractAuthor(rawAuthor: String) -> String {
        
        // http://stackoverflow.com/a/27880748/454925
        func matches(for regex: String, in text: String) -> [String] {
            do {
                let regex = try NSRegularExpression(pattern: regex)
                let nsString = text as NSString
                let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
                return results.map { nsString.substring(with: $0.range)}
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return []
            }
        }
        
        return matches(for: "(?<=nobody@flickr.com \\(\")(.*)(?=\"\\))", in: rawAuthor).first ?? rawAuthor
        
    }
    
}
