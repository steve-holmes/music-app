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
    
    // MARK: Gesture Recognizer
    
    func performSwipeGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        self.delegate?.playerChildViewController(self, didRecognizeBySwipeGestureRecognizer: gestureRecognizer)
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(performSwipeGestureRecognizer(_:)))
        leftSwipeGestureRecognizer.direction = .Left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(performSwipeGestureRecognizer(_:)))
        rightSwipeGestureRecognizer.direction = .Right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
    }

}
