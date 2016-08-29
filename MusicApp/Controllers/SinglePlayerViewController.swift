//
//  SinglePlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/21/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SinglePlayerViewController: UIViewController, PlayerChildViewController {

    // MARK: Delegation
    
    var delegate: PlayerChildViewControllerDelegate?
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
