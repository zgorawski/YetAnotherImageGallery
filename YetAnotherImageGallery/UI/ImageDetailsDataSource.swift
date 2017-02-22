//
//  ImageDetailsDataSource.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit
import Timepiece

struct ImageDataViewModel {
    let propertyName: String
    let propertyValue: String
}

class ImageDetailsDataSource: NSObject {
    
    fileprivate let cellRI = "ImageDetailsCellRI"
    fileprivate let model: [ImageDataViewModel]
    
    init(flickrFeedItem: FlickrFeedItem) {
        
        model = [
            ImageDataViewModel(propertyName: "Title", propertyValue: flickrFeedItem.title),
            ImageDataViewModel(propertyName: "Author", propertyValue: flickrFeedItem.author),
            ImageDataViewModel(propertyName: "Date taken", propertyValue: flickrFeedItem.dateTaken.string(inDateStyle: .medium, andTimeStyle: .short)),
            ImageDataViewModel(propertyName: "Date published", propertyValue: flickrFeedItem.published.string(inDateStyle: .medium, andTimeStyle: .short)),
            ImageDataViewModel(propertyName: "Tags", propertyValue: flickrFeedItem.tags.joined(separator: ", "))
        ]
    }
}

extension ImageDetailsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRI, for: indexPath)
        cell.textLabel?.text = model[indexPath.section].propertyValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return model[section].propertyName
    }
}
