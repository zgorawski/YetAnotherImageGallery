//
//  FlickrFeedInterpreterTests.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 22/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import XCTest
@testable import YetAnotherImageGallery

class FlickrFeedInterpreterTests: XCTestCase {
    
    func testCorrectData() {
        
        // preparation
        
        let jsonObject = [
            "items": [
                [
                    "media": [ "m": "https://farm1.staticflickr.com/594/32209032964_959f8fea05_m.jpg"],
                    "author": "nobody@flickr.com (\"Test name\")",
                    "author_id": "21496267@N03",
                    "published": "2017-02-22T16:40:19Z",
                    "date_taken": "2017-02-12T14:35:55-08:00",
                    "title": "Test title",
                    "tags": "tag1 tag2"
                ]
            ]
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject) else {
            XCTFail()
            return
        }
        
        let httpResponse = HTTPURLResponse(url: URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let interpreter = FlickrFeedInterpreter()
        
        // execution
        
        let interpretedData = interpreter.interpret(data: data, response: httpResponse, error: nil)
        
        // check
        
        guard case Response.success(let feedItems) = interpretedData else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(feedItems.count, 1)
        
        if let feedItem = feedItems.first {
            
            XCTAssertEqual(feedItem.title, "Test title")
            // TODO: check other JSON fields
        }
    }
    
    // TODO:
    // use test coverage tool from xcode to identify other cases, besides success scenario
    
}
