//
//  ImageDetailsDataSource.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit
import Timepiece

class ImageDetailsDataSource: NSObject {
    
    fileprivate let cellRI = "ImageDetailsCellRI"
    var model: FlickrFeedItem
    
    init(model: FlickrFeedItem) {
        self.model = model
    }
}

extension ImageDetailsDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRI, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = model.title
            cell.textLabel?.text = "Title"
        case 1:
            cell.detailTextLabel?.text = model.author
            cell.textLabel?.text = "Author"
        case 2:
            cell.detailTextLabel?.text = model.authorId
            cell.textLabel?.text = "AuthorId"
        case 3:
            cell.detailTextLabel?.text = model.dateTaken.string(inDateStyle: .medium, andTimeStyle: .short)
            cell.textLabel?.text = "Date taken"
        case 4:
            cell.detailTextLabel?.text = model.published.string(inDateStyle: .medium, andTimeStyle: .short)
            cell.textLabel?.text = "Published"
        case 5:
            cell.detailTextLabel?.text = model.tags.joined(separator: ", ")
            cell.textLabel?.text = "Tags"
        default:
            break
        }
        
        return cell
    }
}
