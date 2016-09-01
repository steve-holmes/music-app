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
        
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByTapGestureRecognizer(_:))))
        
        setupPlayerView()
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
    
    // MARK: Player View
    
    private let transitionDuration: NSTimeInterval = 0.35
    
    private func setupPlayerView() {
        playerView.alpha = 0
        playerViewTopConstraint.constant = self.view.bounds.height
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didRecognizeOnPlayerViewByPanGestureRecognizer(_:)))
//        panGestureRecognizer.delegate = self
//        playerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func didRecognizeOnPlayerViewByPanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        guard playerViewController.isMiddleViewOfScrollView() else { return }
        
        let offsetY = gestureRecognizer.translationInView(self.view).y
        guard offsetY > 0 else { return }
        
        let height = self.view.bounds.size.height
        let opacity = 1.0 - offsetY / height
        
        switch gestureRecognizer.state {
        case .Changed:
            if offsetY > height {
                playerViewTopConstraint.constant = height
                playerView.alpha = 0
            } else {
                playerViewTopConstraint.constant = offsetY
                playerView.alpha = opacity
            }
        case .Ended:
            if offsetY < height / 2 {
                UIView.animateWithDuration(
                    transitionDuration,
                    animations: {
                        self.playerViewTopConstraint.constant = 0
                        self.playerView.alpha = 1
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .LightContent
                        self.setNeedsStatusBarAppearanceUpdate()
                    }
                )
            } else if offsetY < height {
                UIView.animateWithDuration(
                    transitionDuration,
                    animations: {
                        self.playerViewTopConstraint.constant = height
                        self.playerView.alpha = 0
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .Default
                        self.setNeedsStatusBarAppearanceUpdate()
                    }
                )
            }
        default:
            break
        }
    }
    
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
    
    private var tapCount = 0
    private var maximumNumberOfTap = 2
    
    func didRecognizeOnMiddleViewByTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        if playerViewController == nil {
            playerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.PlayerController) as! PlayerViewController
            self.displayContentController(playerViewController, inView: self.playerView)
            playerViewController.delegate = self
        }
        
        tapCount += 1
        if tapCount == maximumNumberOfTap {
            tapCount = 0
            maximumNumberOfTap = 1
            UIView.animateWithDuration(transitionDuration) {
                self.playerViewTopConstraint.constant = 0
                self.playerView.alpha = 1
                
                self.view.layoutIfNeeded()
            }
            UIView.animateWithDuration(
                transitionDuration,
                animations: {
                    self.playerViewTopConstraint.constant = 0
                    self.playerView.alpha = 1
                    self.view.layoutIfNeeded()
                },
                completion: { finished in
                    guard finished else { return }
                    self.statusBarStyle = .LightContent
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            )
        }
        
        if animationEnabled { return }
        animatePlayButton() {
            self.tapCount = 0
            self.maximumNumberOfTap = 2
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
    
    // MARK: Status bar
    
    private var statusBarStyle: UIStatusBarStyle = .Default
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.statusBarStyle
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

// MARK: PlayerViewControllerDelegate

extension HomeViewController: PlayerViewControllerDelegate {
    
    func playerViewController(controller: PlayerViewController, onOuterView outerView: UIView, didRecognizeByPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        print(#function)
        didRecognizeOnPlayerViewByPanGestureRecognizer(gestureRecognizer)
    }
    
    func dismissPlayerViewController(controller: PlayerViewController, completion: (() -> Void)?) {
        UIView.animateWithDuration(
            transitionDuration,
            animations: {
                self.playerViewTopConstraint.constant = self.view.bounds.size.height
                self.playerView.alpha = 0
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                guard completed else { return }
                self.statusBarStyle = .Default
                self.setNeedsStatusBarAppearanceUpdate()
                if let completion = completion { completion() }
            }
        )
    }
    
}
