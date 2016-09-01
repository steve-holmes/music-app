//
//  ListPlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/21/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class ListPlayerViewController: UIViewController, PlayerChildViewController {

    // MARK: - Models
    
    var songs: [String] = [
        "aaaa",
        "bbbb"
    ]
    
    // MARK: - Outlets
    
    @IBOutlet weak var songTableView: UITableView!
    
    // MARK: Delegation
    
    var delegate: PlayerChildViewControllerDelegate?
    
    // MARK: Gesture Recognizer
    
    func performSwipeGesureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        self.delegate?.playerChildViewController(self, didRecognizeBySwipeGestureRecognizer: gestureRecognizer)
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.rowHeight = UITableViewAutomaticDimension
        songTableView.estimatedRowHeight = 20
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(performSwipeGesureRecognizer(_:)))
        swipeGestureRecognizer.direction = .Left
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }

}

// MARK: UITableViewDataSource

extension ListPlayerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.ListPlayerTableCell, forIndexPath: indexPath)
        
        if let listCell = cell as? ListPlayerTableViewCell {
            listCell.backgroundColor = UIColor.clearColor()
        }
        
        return cell
    }
    
}
