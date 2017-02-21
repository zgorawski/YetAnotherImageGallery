//
//  ImageListTableDataSource.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit
import AlamofireImage

enum ImageListSortOption {
    case dateTaken, datePublished
}

class ImageListTableDataSource: NSObject {
    
    // dependencies
    fileprivate let flickrFeedController: FlickrFeedController // TODO: make it protocol type, to allow mocking
    
    // properties
    fileprivate var emptyModelMessage: String? = "Loading images"
    fileprivate var model: [FlickrFeedItem] = []
    fileprivate weak var tableView: UITableView!
    
    init(tableView: UITableView, flickrFeedController: FlickrFeedController = FlickrFeedController()) {
        
        self.tableView = tableView
        self.flickrFeedController = flickrFeedController
    }
    
    // MARK: API
    func refreshData() {
        
        flickrFeedController.fetchFeed { [weak self] response in
            
            switch response {
            case .success(let feedItems):
                self?.model = feedItems
                self?.emptyModelMessage = nil
            case .error(let error):
                self?.model = []
                self?.emptyModelMessage = error.localizedDescription
            }
            
            self?.tableView.reloadData()
        }
    }
    
    func getFeedItem(_ indexPath: IndexPath) -> FlickrFeedItem {
        return model[indexPath.row]
    }
    
    func sortBy(_ option: ImageListSortOption) {
        
        switch option {
        case .datePublished:
            model.sort(by: { $0.published > $1.published})
        case .dateTaken:
            model.sort(by: { $0.dateTaken > $1.dateTaken})
        }
        
        tableView.reloadData() //TODO: this is lazy way to sort TV - refactor
    }
    
}

extension ImageListTableDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let feedModel = model[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageListTableViewCell.self), for: indexPath) as! ImageListTableViewCell
        
        cell.mainImageView.af_setImage(withURL: feedModel.imageUrl) // af_setImage also does caching
        cell.descriptionLabel.text = feedModel.author
        
        return cell
    }
}
