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
    @IBOutlet weak var playButtonImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var playerViewTopConstraint: NSLayoutConstraint!
    
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
        
        playerViewTopConstraint.constant = self.view.bounds.height
        
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByTapGestureRecognizer(_:))))
        
        setupPlayButton()
        state = .Online
    }
    
    // MARK: Child View Controllers
    
    private lazy var mineViewController: UINavigationController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.OfflineController) as! UINavigationController
        self.displayContentController(controller, inView: self.backgroundView)
        return controller
    }()
    
    private lazy var onlineViewController: OnlineViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.OnlineController) as! OnlineViewController
        self.displayContentController(controller, inView: self.backgroundView)
        return controller
    }()
    
    private var playerViewController: PlayerViewController!
    
    // MARK: Play Button
    private func setupPlayButton() {
        middleView.layer.borderColor = ColorConstants.toolbarBorderColor.CGColor
        middleView.layer.borderWidth = 1
        middleView.layer.cornerRadius = middleView.frame.size.width / 2
        
        innerView.layer.borderColor = ColorConstants.mainColor.CGColor
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.layer.frame.size.width / 2
        innerView.clipsToBounds = true
        
        let playImage = playButtonImageView.image?.imageWithColor(UIColor.whiteColor())
        playButtonImageView.image = playImage
    }
    
    // MARK: Gesture Recognizer
    
    func didRecognizeOnMiddleViewByTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        if animationEnabled { return }
        
        if playerViewController == nil {
            playerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.PlayerController) as! PlayerViewController
            self.displayContentController(playerViewController, inView: self.playerView)
            playerViewController.delegate = self
        }
        
        animatePlayButton() {
            UIView.animateWithDuration(0.5) {
                self.playerViewTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: The Animation of Play Button
    
    private var animationEnabled = false
    private var animationCount = 0
    private var animationTotal = 4
    private var animationDuration: NSTimeInterval = 6
    
    private func animatePlayButton(completion: (() -> Void)? = nil) {
        playButtonImageView.hidden = true
        UIView.animateWithDuration(
            animationDuration / NSTimeInterval(animationTotal),
            delay: 0,
            options: .CurveLinear,
            animations: {
                self.animationEnabled = true
                self.animationCount += 1
                
                self.playImageView.layer.transform = CATransform3DRotate(self.playImageView.layer.transform, CGFloat(2.0 * M_PI / Double(self.animationTotal)), 0, 0, 1)
            },
            completion: { completed in
                guard completed else {
                    self.animationEnabled = false
                    self.animationCount = 0
                    self.playButtonImageView.hidden = false
                    return
                }
                
                guard self.animationCount == self.animationTotal else {
                    self.animatePlayButton(completion)
                    return
                }
                
                self.animationEnabled = false
                self.animationCount = 0
                self.playButtonImageView.hidden = false
                
                // The last completion
                if let completion = completion { completion() }
            }
        )
    }
    
    // MARK: State
    
    private enum State {
        case Mine
        case Online
    }
    
    private var state: State = .Online {
        didSet {
            switch state {
            case .Mine:
                backgroundView.bringSubviewToFront(mineViewController.view)
                
                let mineImage = mineButtonImageView.image?.imageWithColor(UIColor.whiteColor())
                let onlineImage = onlineButtonImageView.image?.imageWithColor(ColorConstants.toolbarImageColor)
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = UIColor.whiteColor()
                onlineButtonLabel.textColor = ColorConstants.textColor
                
                mineButtonBackgroundView.backgroundColor = ColorConstants.mainColor
                onlineButtonBackgroundView.backgroundColor = ColorConstants.toolbarNormalBackgroundColor
            case .Online:
                backgroundView.bringSubviewToFront(onlineViewController.view)
                
                let mineImage = mineButtonImageView.image?.imageWithColor(ColorConstants.toolbarImageColor)
                let onlineImage = onlineButtonImageView.image?.imageWithColor(UIColor.whiteColor())
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = ColorConstants.textColor
                onlineButtonLabel.textColor = UIColor.whiteColor()
                
                mineButtonBackgroundView.backgroundColor = ColorConstants.toolbarNormalBackgroundColor
                onlineButtonBackgroundView.backgroundColor = ColorConstants.mainColor
            }
        }
    }

}

extension HomeViewController: PlayerViewControllerDelegate {
    
    func dismissPlayerViewController(controller: PlayerViewController, completion: (() -> Void)?) {
        UIView.animateWithDuration(
            0.5,
            animations: {
                self.playerViewTopConstraint.constant = self.view.bounds.size.height
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                guard completed else { return }
                if let completion = completion { completion() }
            }
        )
    }
    
}
