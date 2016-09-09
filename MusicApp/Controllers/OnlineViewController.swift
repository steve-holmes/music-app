//
//  OnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit
import PageMenu

class OnlineViewController: UIViewController {

    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageMenu()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Page Menu
    
    private var pageMenu: CAPSPageMenu!
    
    private func setupPageMenu() {
        let childControllers: [UIViewController] = [
            (ControllersIdentifiers.HomeOnlineController,       "Home"),
            (ControllersIdentifiers.PlaylistOnlineController,   "Playlist"),
            (ControllersIdentifiers.SongOnlineController,       "Song"),
            (ControllersIdentifiers.VideoOnlineController,      "Video"),
            (ControllersIdentifiers.RankOnlineController,       "Rank"),
            (ControllersIdentifiers.SingerOnlineController,     "Singer")
        ].flatMap { controllerTuple in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier(controllerTuple.0)
            controller?.title = controllerTuple.1
            return controller
        }
        
        self.pageMenu = CAPSPageMenu(viewControllers: childControllers, frame: self.view.bounds, pageMenuOptions: nil)
        self.view.addSubview(self.pageMenu.view)
    }

}
