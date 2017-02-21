//
//  ImageListViewController.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    
    // dependency
    // TODO: make it injectable
    fileprivate var imageListDataSource : ImageListTableDataSource!
    
    // model
    fileprivate var selectedFeed: FlickrFeedItem?
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // consts
    fileprivate let detailsSegueId = "ImageDetailsSegue"
    
    // MARK: IBActions
    
    @IBAction func onDateTakenTap(_ sender: UIBarButtonItem) {
        imageListDataSource.sortBy(.dateTaken)
    }
    
    @IBAction func onDatePublishedTap(_ sender: UIBarButtonItem) {
        imageListDataSource.sortBy(.datePublished)
    }
    
}

// TODO: move those extensions to sepratate files, if they grow too much

// MARK: VC lifecycle
extension ImageListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imageListDataSource = ImageListTableDataSource(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = imageListDataSource
        imageListDataSource.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Navigation
extension ImageListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            segue.identifier == detailsSegueId,
            let selectedFeed = selectedFeed,
            let vc = segue.destination as? ImageDetailsViewController
        else { return }
        
        vc.selectedFeed = selectedFeed
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFeed = imageListDataSource.getFeedItem(indexPath)
        performSegue(withIdentifier: detailsSegueId, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
