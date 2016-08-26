//
//  OfflineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

}

extension OfflineViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 3
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.OfflineTableCell, forIndexPath: indexPath)
        
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            cell.textLabel?.text = "All Songs"
        case 1:
            switch row {
            case 0: cell.textLabel?.text = "Playlist"
            case 1: cell.textLabel?.text = "Video"
            default: break
            }
        case 2:
            switch row {
            case 0: cell.textLabel?.text = "Song"
            case 1: cell.textLabel?.text = "Playlist"
            case 2: cell.textLabel?.text = "Video"
            default: break
            }
        default: break
        }
        
        return cell
    }
    
}