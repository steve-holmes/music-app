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
            (controller: ControllersIdentifiers.homeOnline,     title: "Home"),
            (controller: ControllersIdentifiers.playlistOnline, title: "Playlist"),
            (controller: ControllersIdentifiers.songOnline,     title: "Song"),
            (controller: ControllersIdentifiers.videoOnline,    title: "Video"),
            (controller: ControllersIdentifiers.rankOnline,     title: "Rank"),
            (controller: ControllersIdentifiers.singerOnline,   title: "Singer")
        ].flatMap { controllerTuple in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerTuple.controller)
            controller?.title = controllerTuple.title
            return controller
        }
        
        self.pageMenu = CAPSPageMenu(viewControllers: childControllers, frame: self.view.bounds, pageMenuOptions: nil)
        self.view.addSubview(self.pageMenu.view)
    }

}
