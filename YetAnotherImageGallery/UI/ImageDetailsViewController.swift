//
//  ImageDetailsViewController.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageDetailsViewController: UIViewController {
    
    // dependencies
    fileprivate var imageDetailsDataSource: ImageDetailsDataSource!
    var imageCache: AutoPurgingImageCache!
    
    // model
    var selectedFeed: FlickrFeedItem!
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // actions

    @IBAction func onShareButtonTap(_ sender: UIBarButtonItem) {
        
        guard let img = imageCache.image(withIdentifier: selectedFeed.imageUrl.absoluteString) else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        
        present(activityViewController, animated: true, completion: nil)
    }
}

// TODO: move those extensions to sepratate files, if they grow too much

// MARK: VC lifecycle
extension ImageDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetailsDataSource = ImageDetailsDataSource(flickrFeedItem: selectedFeed)

        tableView.dataSource = imageDetailsDataSource
        tableView.tableFooterView = UIView() // common hack to hide extra rows
        
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
