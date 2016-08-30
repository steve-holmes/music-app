//
//  SinglePlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/21/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol SinglePlayerViewControllerDelegate {
    
    func singlePlayerViewController(controller: SinglePlayerViewController, didRecognizeByTapGesture gestureRecognizer: UIPanGestureRecognizer)
    
}

class SinglePlayerViewController: UIViewController {

    // MARK: Delegation
    
    var delegate: SinglePlayerViewControllerDelegate?
    
    // MARK: Gesture Recognizer
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    func didRecognizeByTapGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        self.delegate?.singlePlayerViewController(self, didRecognizeByTapGesture: gestureRecognizer)
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didRecognizeByTapGestureRecognizer(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }

}
