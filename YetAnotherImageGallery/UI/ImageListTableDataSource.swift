//
//  ImageListTableDataSource.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit
import AlamofireImage
import DZNEmptyDataSet

enum ImageListSortOption {
    case dateTaken, datePublished
}

class ImageListTableDataSource: NSObject {
    
    // dependencies
    fileprivate let flickrFeedController: FlickrFeedController // TODO: make it protocol type, to allow mocking
    fileprivate let imageCache: AutoPurgingImageCache
    
    // properties
    fileprivate var emptyModelMessage: String? = "Loading images"
    fileprivate var model: [FlickrFeedItem] = []
    fileprivate weak var tableView: UITableView!
    
    init(tableView: UITableView, imageCache: AutoPurgingImageCache, flickrFeedController: FlickrFeedController = FlickrFeedController()) {
        
        self.imageCache = imageCache
        self.tableView = tableView
        self.flickrFeedController = flickrFeedController
        
        super.init()
        
        tableView.emptyDataSetSource = self
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

        cell.mainImageView.af_setImage(withURL: feedModel.imageUrl) { [weak self] imageResponse in
            
            DispatchQueue.main.async {
                guard let image = imageResponse.value else { return }
                self?.imageCache.add(image, withIdentifier: feedModel.imageUrl.absoluteString)
            }
        }
        
        cell.descriptionLabel.text = feedModel.author
        
        return cell
    }
}

extension ImageListTableDataSource: DZNEmptyDataSetSource {
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let message = emptyModelMessage ?? ""
        return NSAttributedString(string: message)
    }
    
}
