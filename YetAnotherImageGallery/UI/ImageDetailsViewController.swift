//
//  ImageDetailsViewController.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    // dependencies
    fileprivate var imageDetailsDataSource: ImageDetailsDataSource!
    
    // model
    var selectedFeed: FlickrFeedItem!
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // actions

}

// TODO: move those extensions to sepratate files, if they grow too much

// MARK: VC lifecycle
extension ImageDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetailsDataSource = ImageDetailsDataSource(model: selectedFeed)

        tableView.dataSource = imageDetailsDataSource
        tableView.tableFooterView = UIView() // common hack to hide extra rows
        
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
