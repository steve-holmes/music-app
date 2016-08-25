//
//  VisualViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/24/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class VisualViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var unloadProgressBar: UIView!
    @IBOutlet weak var playedProgressBar: UIView!
    @IBOutlet weak var sliderView: UIView!
    
    @IBOutlet weak var playButton: CircleButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var sliderViewLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var backwardButtonLeadingSpaceConstriant: NSLayoutConstraint!
    @IBOutlet weak var forwardButtonTrailingSpaceConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backwardButton.setImage(backwardButton.imageForState(.Normal)?.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        forwardButton.setImage(forwardButton.imageForState(.Normal)?.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        
        sliderView.layer.cornerRadius = sliderView.bounds.size.height / 2
        sliderViewLeadingSpaceConstraint.constant = progressBar.frame.size.width * 0.3
        backwardButtonLeadingSpaceConstriant.constant = self.view.bounds.size.width / 4
        forwardButtonTrailingSpaceConstraint.constant = -self.view.bounds.size.width / 4
    }
}

extension VisualViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}