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
    
    // MARK: Page Menu
    
    private var pageMenu: CAPSPageMenu!
    
    private func setupPageMenu() {
        var childControllers = [UIViewController]()
        
        if let homeControlller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.HomeOnlineController) {
            homeControlller.title = "Home"
            childControllers.append(homeControlller)
        }
        
        if let playlistController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.PlaylistOnlineController) {
            playlistController.title = "Playlist"
            childControllers.append(playlistController)
        }
        
        if let songController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.SongOnlineController) {
            songController.title = "Song"
            childControllers.append(songController)
        }
        
        if let rankController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.RankOnlineController) {
            rankController.title = "Rank"
            childControllers.append(rankController)
        }
        
        if let singerController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.SingerOnlineController) {
            singerController.title = "Singer"
            childControllers.append(singerController)
        }
        
        self.pageMenu = CAPSPageMenu(viewControllers: childControllers, frame: self.view.bounds, pageMenuOptions: nil)
        self.view.addSubview(self.pageMenu.view)
    }

}
