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
        
        tableView.backgroundColor = ColorConstants.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private let headerViewRatio: CGFloat = 0.07 // height = ratio * width
    
    func moreButtonTapped(button: UIButton) {
        let section = Int(button.currentTitle!)!
        print(section)
    }
}

// MARK: UITableViewDataSource

extension HomeOnlineViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 { return 3 }
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

extension HomeOnlineViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = tableView.bounds.size.width
        let height = width * headerViewRatio
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let headerLabel = UILabel(frame: CGRect(x: 8, y: 0, width: width / 2 - 8, height: height))
        headerLabel.font = UIFont.avenirNextFont().fontWithSize(15)
        headerView.addSubview(headerLabel)
        
        let accessoryLabel = UILabel(frame: CGRect(x: width / 2, y: 0, width: width / 2 - 8, height: height))
        accessoryLabel.text = "More"
        accessoryLabel.font = UIFont.avenirNextFont().fontWithSize(12)
        accessoryLabel.textAlignment = .Right
        headerView.addSubview(accessoryLabel)
        
        let accessoryButton = UIButton(frame: CGRect(x: 5 * width / 6, y: 0, width: 5 * width / 6 - 8, height: height))
        accessoryButton.setTitle("\(section)", forState: .Normal)
        accessoryButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
        accessoryButton.addTarget(self, action: #selector(moreButtonTapped(_:)), forControlEvents: .TouchUpInside)
        headerView.addSubview(accessoryButton)
        
        switch section {
        case 1: headerLabel.text = "Playlist"
        case 2: headerLabel.text = "Video"
        case 3: headerLabel.text = "Song"
        default: break
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0.01 }
        return tableView.bounds.size.width * headerViewRatio
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}