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
    
    fileprivate let headerViewRatio: CGFloat = 0.07 // height = ratio * width
    
    func moreButtonTapped(_ button: UIButton) {
        let section = Int(button.currentTitle!)!
        print(section)
    }
}

// MARK: UITableViewDataSource

extension HomeOnlineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 { return 10 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0: return self.tableView(tableView, pageCellForRowAtIndexPath: indexPath)
        case 1: return self.tableView(tableView, playlistCellForRowAtIndexPath: indexPath)
        case 2: return self.tableView(tableView, videoCellForRowAtIndexPath: indexPath)
        case 3: return self.tableView(tableView, songCellForRowAtIndexPath: indexPath)
        default: fatalError("has not been implemented")
        }
    }
    
    fileprivate func tableView(_ tableView: UITableView, pageCellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.PageHomeOnlineTableCell, for: indexPath)
        
//        if let pageCell = cell as? PageHomeOnlineTableViewCell {
//            
//        }
        
        return cell
    }
        
    fileprivate func tableView(_ tableView: UITableView, playlistCellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.PlaylistHomeOnlineTableCell, for: indexPath)
        
//        if let playlistCell = cell as? PlaylistHomeOnlineTableViewCell {
//            
//        }
        
        return cell
    }
    
    fileprivate func tableView(_ tableView: UITableView, videoCellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.VideoHomeOnlineTableCell, for: indexPath)
        
//        if let videoCell = cell as? VideoHomeOnlineTableViewCell {
//            
//        }
        
        return cell
    }
    
    fileprivate func tableView(_ tableView: UITableView, songCellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.SongHomeOnlineTableCell, for: indexPath)
        
        if let songCell = cell as? SongHomeOnlineTableViewCell {
            songCell.songName = "Gui Anh Xa Nho"
            songCell.singerName = "Bich Phuong"
        }
        
        return cell
    }
    
}

extension HomeOnlineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        let width = tableView.bounds.size.width
        let height = width * headerViewRatio
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let headerLabel = UILabel(frame: CGRect(x: 8, y: 0, width: width / 2 - 8, height: height))
        headerLabel.font = UIFont.avenirNextFont().withSize(15)
        headerView.addSubview(headerLabel)
        
        let accessoryLabel = UILabel(frame: CGRect(x: width / 2, y: 0, width: width / 2 - 8, height: height))
        accessoryLabel.text = "More"
        accessoryLabel.font = UIFont.avenirNextFont().withSize(12)
        accessoryLabel.textAlignment = .right
        headerView.addSubview(accessoryLabel)
        
        let accessoryButton = UIButton(frame: CGRect(x: 5 * width / 6, y: 0, width: 5 * width / 6 - 8, height: height))
        accessoryButton.setTitle("\(section)", for: UIControlState())
        accessoryButton.setTitleColor(UIColor.clear, for: UIControlState())
        accessoryButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(accessoryButton)
        
        switch section {
        case 1: headerLabel.text = "Playlist"
        case 2: headerLabel.text = "Video"
        case 3: headerLabel.text = "Song"
        default: break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0.01 }
        return tableView.bounds.size.width * headerViewRatio
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 { return 90 }
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
