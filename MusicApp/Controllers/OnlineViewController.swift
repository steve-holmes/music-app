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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Page Menu
    
    fileprivate var pageMenu: CAPSPageMenu!
    
    fileprivate func setupPageMenu() {
        let childControllers: [UIViewController] = [
            (ControllersIdentifiers.homeOnline,       "Home"),
            (ControllersIdentifiers.playlistOnline,   "Playlist"),
            (ControllersIdentifiers.songOnline,       "Song"),
            (ControllersIdentifiers.videoOnline,      "Video"),
            (ControllersIdentifiers.rankOnline,       "Rank"),
            (ControllersIdentifiers.singerOnline,     "Singer")
        ].flatMap { controllerTuple in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerTuple.0)
            controller?.title = controllerTuple.1
            return controller
        }
        
        self.pageMenu = CAPSPageMenu(viewControllers: childControllers, frame: self.view.bounds, pageMenuOptions: nil)
        self.view.addSubview(self.pageMenu.view)
    }

}
