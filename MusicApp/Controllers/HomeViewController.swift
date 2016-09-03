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
    @IBOutlet weak var middleViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerViewBottomConstraint: NSLayoutConstraint!
    
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByTapGestureRecognizer(_:)))
        middleView.addGestureRecognizer(tapGestureRecognizer)
        innerView.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByPanGestureRecognizer(_:)))
        tapGestureRecognizer.requireGestureRecognizerToFail(panGestureRecognizer)
        panGestureRecognizer.enabled = false
        middleView.addGestureRecognizer(panGestureRecognizer)
        innerView.addGestureRecognizer(panGestureRecognizer)
        
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
    
    private lazy var onlineViewController: UINavigationController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.OnlineController) as! UINavigationController
        self.displayContentController(controller, inView: self.backgroundView)
        return controller
    }()
    
    private var playerViewController: PlayerViewController!
    
    // MARK: Player View
    
    private let transitionDuration: NSTimeInterval = 0.35
    
    private func setupPlayerView() {
        playerView.alpha = 0
        playerViewTopConstraint.constant = self.view.bounds.height
        
    }
    
    // MARK: Play Button
    
    private lazy var centerPointBottomConstant: CGFloat = 7 * self.view.bounds.size.width / 100
    private lazy var outerRadius: CGFloat = 3 * self.view.bounds.size.width / 100
    private lazy var bottomConstant: CGFloat = 10
    
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
        
        middleViewBottomConstraint.constant = -bottomConstant
        innerViewBottomConstraint.constant = outerRadius - bottomConstant
    }
    
    // MARK: Gesture Recognizer
    
    private var tapCount = 0
    private var maximumNumberOfTap = 2
    
    func didRecognizeOnMiddleViewByTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        if playerViewController == nil {
            playerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.PlayerController) as? PlayerViewController
            self.displayContentController(playerViewController, inView: self.playerView)
            playerViewController.delegate = self
            panGestureRecognizer.enabled = true
        }
        
        tapCount += 1
        if tapCount == maximumNumberOfTap {
            tapCount = 0
            maximumNumberOfTap = 1
            UIView.animateWithDuration(transitionDuration) {
                self.setPropertiesForEndedState()
            }
            UIView.animateWithDuration(
                transitionDuration,
                animations: {
                    self.setPropertiesForEndedState()
                },
                completion: { finished in
                    guard finished else { return }
                    self.statusBarStyle = .LightContent
                }
            )
        }
        
        if animationEnabled { return }
        animatePlayButton() {
            self.tapCount = 0
            self.maximumNumberOfTap = 2
        }
    }
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    func didRecognizeOnMiddleViewByPanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        var offsetY = gestureRecognizer.translationInView(self.view).y
        guard offsetY < 0 else { return }
        
        offsetY = abs(offsetY)
        let height = self.view.bounds.size.height
        
        switch gestureRecognizer.state {
        case .Changed:
            setPropertiesForChangedStateAtOffsetY(offsetY, forDirection: .FromBottomToTop)
        case .Ended:
            if offsetY < height / 2 {
                UIView.animateWithDuration(
                    transitionDuration,
                    animations: {
                        self.setPropertiesForBeganState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .Default
                    }
                )
            } else if offsetY < height {
                UIView.animateWithDuration(
                    transitionDuration,
                    animations: {
                        self.setPropertiesForEndedState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .LightContent
                    }
                )
            }
        default:
            break
        }
    }
    
    // MARK: Set Properties for Changed state or Ended state
    
    private enum PlayerViewDirection {
        case FromTopToBottom
        case FromBottomToTop
    }
    
    private func setPropertiesForChangedStateAtOffsetY(offsetY: CGFloat, forDirection direction: PlayerViewDirection) {
        let height = self.view.bounds.size.height
        var offset = offsetY
        
        func setPropertiesForChangedStateFromTopToBottom() {
            offset = height - offset
            setPropertiesForChangedStateFromBottomToTop()
        }
        
        func setPropertiesForChangedStateFromBottomToTop() {
            playerViewTopConstraint.constant = height - offset
            playerView.alpha = offset / height
            
            if offset < centerPointBottomConstant {
                middleViewBottomConstraint.constant = -bottomConstant
                innerViewBottomConstraint.constant = outerRadius - bottomConstant
                middleView.alpha = 1
            } else if offset > centerPointBottomConstant {
                middleViewBottomConstraint.constant = offset - bottomConstant - centerPointBottomConstant
                innerViewBottomConstraint.constant = centerPointBottomConstant + outerRadius - bottomConstant - offset
                middleView.alpha = playerView.alpha
            }
        }
        
        switch direction {
        case .FromTopToBottom: setPropertiesForChangedStateFromTopToBottom()
        case .FromBottomToTop: setPropertiesForChangedStateFromBottomToTop()
        }
    }
    
    private func setPropertiesForEndedState() {
        let height = self.view.bounds.size.height
        playerViewTopConstraint.constant = 0
        playerView.alpha = 1
        middleView.alpha = 0
        middleViewBottomConstraint.constant = height - bottomConstant
        innerViewBottomConstraint.constant = outerRadius - bottomConstant - height
        self.view.layoutIfNeeded()
    }
    
    private func setPropertiesForBeganState() {
        let height = self.view.bounds.size.height
        playerViewTopConstraint.constant = height
        playerView.alpha = 0
        middleView.alpha = 1
        middleViewBottomConstraint.constant = -bottomConstant
        innerViewBottomConstraint.constant = outerRadius - bottomConstant
        self.view.layoutIfNeeded()
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
    
    private var statusBarStyle: UIStatusBarStyle = .Default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
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
    
    func playerViewController(controller: PlayerViewController, didRecognizeByPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer, completion: (() -> Void)? = nil) {
        guard playerViewController.isMiddleViewOfScrollView() else { return }
        
        let offsetY = gestureRecognizer.translationInView(self.view).y
        guard offsetY > 0 else { return }
        
        let height = self.view.bounds.size.height
        
        switch gestureRecognizer.state {
        case .Changed:
            setPropertiesForChangedStateAtOffsetY(offsetY, forDirection: .FromTopToBottom)
        case .Ended:
            if offsetY < height / 2 {
                UIView.animateWithDuration(
                    transitionDuration,
                    animations: {
                        self.setPropertiesForEndedState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .LightContent
                        completion?()
                    }
                )
            } else if offsetY < height {
                UIView.animateWithDuration(
                    transitionDuration,
                    animations: {
                        self.setPropertiesForBeganState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .Default
                        completion?()
                    }
                )
            }
        default:
            break
        }
    }
    
    func dismissPlayerViewController(controller: PlayerViewController, completion: (() -> Void)?) {
        UIView.animateWithDuration(
            transitionDuration,
            animations: {
                self.setPropertiesForBeganState()
            },
            completion: { completed in
                guard completed else { return }
                self.statusBarStyle = .Default
                completion?()
            }
        )
    }
    
}
