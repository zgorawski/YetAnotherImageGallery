//
//  FlickrFeedModel.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Foundation

struct FlickrFeedItem {
    
}

enum FlickrFeedError: Error {
    
    case genericFail
    // TODO: handle more scenarios, currently simplified for demo purposes
    
    var localizedDescription: String {
        switch self {
        case .genericFail: return "Unable to provide flickr feed"
        }
    }
}
