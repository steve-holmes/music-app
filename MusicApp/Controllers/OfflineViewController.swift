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
    
    @IBAction func settingBarButtonTapped(_ settingItem: UIBarButtonItem) {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = ColorConstants.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionFooterHeight = 0.01
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

extension OfflineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 3
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.OfflineTableCell, for: indexPath)
        
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "My Song"
        case 2: return "Offline"
        default: return nil
        }
    }
    
}

extension OfflineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = (indexPath as NSIndexPath).section
        let row = (indexPath as NSIndexPath).row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch section {
        case 0:
            break
        case 1:
            if Authentication.sharedAuthentication.validated {
                switch row {
                case 0: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.PlaylistMineController)
                case 1: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.VideoMineController)
                default: break
                }
            } else {
                switch row {
                case 0, 1: self.pushChildOfflineViewControllerWithIdentifier(ControllersIdentifiers.LoginController)
                default: break
                }
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
    
    fileprivate func pushChildOfflineViewControllerWithIdentifier(_ identifier: String) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
