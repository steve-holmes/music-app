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
    
    @IBAction func settingBarButtonTapped(settingItem: UIBarButtonItem) {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionFooterHeight = 0.01
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
        
        cell.textLabel?.textColor = ColorConstants.textColor
        
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "My Song"
        case 2: return "Offline"
        default: return nil
        }
    }
    
}

extension OfflineViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch section {
        case 0:
            break
        case 1:
            switch row {
            case 0: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.PlaylistMineController)
            case 1: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.VideoMineController)
            default: break
            }
        case 2:
            switch row {
            case 0: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.SongOfflineController)
            case 1: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.PlaylistOfflineController)
            case 2: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.VideoOfflineController)
            default: break
            }
        default:
            break
        }
    }
    
    private func pushChildOfflineViewControllerWithIdentifier(identifier: String) {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}