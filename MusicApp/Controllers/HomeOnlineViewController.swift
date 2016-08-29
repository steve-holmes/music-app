//
//  HomeOnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class HomeOnlineViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
}

// MARK: UITableViewDataSource

extension HomeOnlineViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return self.tableView(tableView, pageCellForRowAtIndexPath: indexPath)
        case 1: return self.tableView(tableView, playlistCellForRowAtIndexPath: indexPath)
        case 2: return self.tableView(tableView, videoCellForRowAtIndexPath: indexPath)
        case 3: return self.tableView(tableView, songCellForRowAtIndexPath: indexPath)
        default: fatalError("has not been implemented")
        }
    }
    
    private func tableView(tableView: UITableView, pageCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.PageHomeOnlineTableCell, forIndexPath: indexPath)
        
//        if let pageCell = cell as? PageHomeOnlineTableViewCell {
//            
//        }
        
        return cell
    }
        
    private func tableView(tableView: UITableView, playlistCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.PlaylistHomeOnlineTableCell, forIndexPath: indexPath)
        
//        if let playlistCell = cell as? PlaylistHomeOnlineTableViewCell {
//            
//        }
        
        return cell
    }
    
    private func tableView(tableView: UITableView, videoCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.VideoHomeOnlineTableCell, forIndexPath: indexPath)
        
//        if let videoCell = cell as? VideoHomeOnlineTableViewCell {
//            
//        }
        
        return cell
    }
    
    private func tableView(tableView: UITableView, songCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.SongHomeOnlineTableCell, forIndexPath: indexPath)
        
        if let songCell = cell as? SongHomeOnlineTableViewCell {
            songCell.songName = "Gui Anh Xa Nho"
            songCell.singerName = "Bich Phuong"
        }
        
        return cell
    }
    
}