//
//  HomeViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mineButtonImageView: UIImageView!
    @IBOutlet weak var mineButtonLabel: UILabel!
    @IBOutlet weak var mineButtonBackgroundView: UIView!
    
    @IBOutlet weak var onlineButtonImageView: UIImageView!
    @IBOutlet weak var onlineButtonLabel: UILabel!
    @IBOutlet weak var onlineButtonBackgroundView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var playImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: Actions
    
    @IBAction func mineButtonTapped() {
        if state == .Online {
            state = .Mine
        }
    }
    
    @IBAction func onlineButtonTapped() {
        if state == .Mine {
            state = .Online
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByTapGestureRecognizer(_:))))
        
        setupPlayButton()
        state = .Online
    }
    
    // MARK: Child View Controllers
    
    private lazy var mineViewController: OfflineViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.OfflineController) as! OfflineViewController
        self.displayContentController(controller, inView: self.backgroundView)
        return controller
    }()
    
    private lazy var onlineViewController: OnlineViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.OnlineController) as! OnlineViewController
        self.displayContentController(controller, inView: self.backgroundView)
        return controller
    }()
    
    // MARK: Play Button
    private func setupPlayButton() {
        middleView.layer.borderColor = ColorConstants.toolbarBorderColor.CGColor
        middleView.layer.borderWidth = 1
        middleView.layer.cornerRadius = middleView.frame.size.width / 2
        
        innerView.layer.borderColor = ColorConstants.toolbarHighlightedBackgroundColor.CGColor
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.layer.frame.size.width / 2
        innerView.clipsToBounds = true
        
        let image = playImageView.image?.imageWithColor(UIColor.whiteColor())
        playImageView.image = image
    }
    
    // MARK: Gesture Recognizer
    
    func didRecognizeOnMiddleViewByTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        print(#function)
    }
    
    // MARK: State
    
    enum State {
        case Mine
        case Online
    }
    
    var state: State = .Online {
        didSet {
            switch state {
            case .Mine:
                backgroundView.bringSubviewToFront(mineViewController.view)
                
                let mineImage = mineButtonImageView.image?.imageWithColor(UIColor.whiteColor())
                let onlineImage = onlineButtonImageView.image?.imageWithColor(ColorConstants.toolbarImageColor)
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = UIColor.whiteColor()
                onlineButtonLabel.textColor = ColorConstants.toolbarTextColor
                
                mineButtonBackgroundView.backgroundColor = ColorConstants.toolbarHighlightedBackgroundColor
                onlineButtonBackgroundView.backgroundColor = ColorConstants.toolbarNormalBackgroundColor
            case .Online:
                backgroundView.bringSubviewToFront(onlineViewController.view)
                
                let mineImage = mineButtonImageView.image?.imageWithColor(ColorConstants.toolbarImageColor)
                let onlineImage = onlineButtonImageView.image?.imageWithColor(UIColor.whiteColor())
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = ColorConstants.toolbarTextColor
                onlineButtonLabel.textColor = UIColor.whiteColor()
                
                mineButtonBackgroundView.backgroundColor = ColorConstants.toolbarNormalBackgroundColor
                onlineButtonBackgroundView.backgroundColor = ColorConstants.toolbarHighlightedBackgroundColor
            }
        }
    }

}
