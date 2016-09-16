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
        if state == .online {
            state = .mine
        }
    }
    
    @IBAction func onlineButtonTapped() {
        if state == .mine {
            state = .online
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByTapGestureRecognizer(_:)))
        middleView.addGestureRecognizer(tapGestureRecognizer)
        innerView.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didRecognizeOnMiddleViewByPanGestureRecognizer(_:)))
        tapGestureRecognizer.require(toFail: panGestureRecognizer)
        panGestureRecognizer.isEnabled = false
        middleView.addGestureRecognizer(panGestureRecognizer)
        innerView.addGestureRecognizer(panGestureRecognizer)
        
        setupPlayerView()
        setupPlayButton()
        state = .online
    }
    
    // MARK: Child View Controllers
    
    fileprivate lazy var mineViewController: UINavigationController = {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ControllersIdentifiers.offline) as! UINavigationController
        self.display(contentController: controller, in: self.backgroundView)
        return controller
    }()
    
    fileprivate lazy var onlineViewController: UINavigationController = {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ControllersIdentifiers.online) as! UINavigationController
        self.display(contentController: controller, in: self.backgroundView)
        return controller
    }()
    
    fileprivate var playerViewController: PlayerViewController!
    
    // MARK: Player View
    
    fileprivate let transitionDuration: TimeInterval = 0.35
    
    fileprivate func setupPlayerView() {
        playerView.alpha = 0
        playerViewTopConstraint.constant = self.view.bounds.height
        
    }
    
    // MARK: Play Button
    
    fileprivate lazy var centerPointBottomConstant: CGFloat = 7 * self.view.bounds.size.width / 100
    fileprivate lazy var outerRadius: CGFloat = 3 * self.view.bounds.size.width / 100
    fileprivate lazy var bottomConstant: CGFloat = 10
    
    fileprivate func setupPlayButton() {
        middleView.layer.borderColor = ColorConstants.toolbarBorder.cgColor
        middleView.layer.borderWidth = 1
        middleView.layer.cornerRadius = middleView.frame.size.width / 2
        
        innerView.layer.borderColor = ColorConstants.main.cgColor
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.layer.frame.size.width / 2
        innerView.clipsToBounds = true
        
        let playImage = playButtonImageView.image?.image(withColor: UIColor.white)
        playButtonImageView.image = playImage
        
        middleViewBottomConstraint.constant = -bottomConstant
        innerViewBottomConstraint.constant = outerRadius - bottomConstant
    }
    
    // MARK: Gesture Recognizer
    
    fileprivate var tapCount = 0
    fileprivate var maximumNumberOfTap = 2
    
    func didRecognizeOnMiddleViewByTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        if playerViewController == nil {
            playerViewController = self.storyboard?.instantiateViewController(withIdentifier: ControllersIdentifiers.player) as? PlayerViewController
            self.display(contentController: playerViewController, in: self.playerView)
            playerViewController.delegate = self
            panGestureRecognizer.isEnabled = true
        }
        
        tapCount += 1
        if tapCount == maximumNumberOfTap {
            tapCount = 0
            maximumNumberOfTap = 1
            UIView.animate(withDuration: transitionDuration, animations: {
                self.setPropertiesForEndedState()
            }) 
            UIView.animate(
                withDuration: transitionDuration,
                animations: {
                    self.setPropertiesForEndedState()
                },
                completion: { finished in
                    guard finished else { return }
                    self.statusBarStyle = .lightContent
                }
            )
        }
        
        if animationEnabled { return }
        animatePlayButton() {
            self.tapCount = 0
            self.maximumNumberOfTap = 2
        }
    }
    
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    func didRecognizeOnMiddleViewByPanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        var offsetY = gestureRecognizer.translation(in: self.view).y
        guard offsetY < 0 else { return }
        
        offsetY = abs(offsetY)
        let height = self.view.bounds.size.height
        
        switch gestureRecognizer.state {
        case .changed:
            setPropertiesForChangedState(atOffsetY: offsetY, forDirection: .fromBottomToTop)
        case .ended:
            if offsetY < height / 2 {
                UIView.animate(
                    withDuration: transitionDuration,
                    animations: {
                        self.setPropertiesForBeganState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .default
                    }
                )
            } else if offsetY < height {
                UIView.animate(
                    withDuration: transitionDuration,
                    animations: {
                        self.setPropertiesForEndedState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .lightContent
                    }
                )
            }
        default:
            break
        }
    }
    
    // MARK: Set Properties for Changed state or Ended state
    
    fileprivate enum PlayerViewDirection {
        case fromTopToBottom
        case fromBottomToTop
    }
    
    fileprivate var startAlpha: CGFloat = 0.2
    fileprivate var endAlpha: CGFloat   = 1
    fileprivate lazy var scaleAlphaFactor: CGFloat = self.endAlpha - self.startAlpha
    
    fileprivate func setPropertiesForChangedState(atOffsetY offsetY: CGFloat, forDirection direction: PlayerViewDirection) {
        let height = self.view.bounds.size.height
        var offset = offsetY
        
        func setPropertiesForChangedStateFromTopToBottom() {
            offset = height - offset
            setPropertiesForChangedStateFromBottomToTop()
        }
        
        func setPropertiesForChangedStateFromBottomToTop() {
            playerViewTopConstraint.constant = height - offset
            playerView.alpha = startAlpha + scaleAlphaFactor * offset / height
            
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
        case .fromTopToBottom: setPropertiesForChangedStateFromTopToBottom()
        case .fromBottomToTop: setPropertiesForChangedStateFromBottomToTop()
        }
    }
    
    fileprivate func setPropertiesForEndedState() {
        let height = self.view.bounds.size.height
        playerViewTopConstraint.constant = 0
        playerView.alpha = endAlpha
        middleView.alpha = 0
        middleViewBottomConstraint.constant = height - bottomConstant
        innerViewBottomConstraint.constant = outerRadius - bottomConstant - height
        self.view.layoutIfNeeded()
    }
    
    fileprivate func setPropertiesForBeganState() {
        let height = self.view.bounds.size.height
        playerViewTopConstraint.constant = height
        playerView.alpha = startAlpha
        middleView.alpha = 1
        middleViewBottomConstraint.constant = -bottomConstant
        innerViewBottomConstraint.constant = outerRadius - bottomConstant
        self.view.layoutIfNeeded()
    }
    
    // MARK: The Animation of Play Button
    
    fileprivate var animationEnabled = false
    fileprivate var animationCount = 0
    fileprivate var animationTotal = 4
    fileprivate var animationDuration: TimeInterval = 6
    
    fileprivate func animatePlayButton(_ completion: (() -> Void)? = nil) {
        playButtonImageView.isHidden = true
        UIView.animate(
            withDuration: animationDuration / TimeInterval(animationTotal),
            delay: 0,
            options: .curveLinear,
            animations: {
                self.animationEnabled = true
                self.animationCount += 1
                
                self.playImageView.layer.transform = CATransform3DRotate(self.playImageView.layer.transform, CGFloat(2.0 * M_PI / Double(self.animationTotal)), 0, 0, 1)
            },
            completion: { completed in
                guard completed else {
                    self.animationEnabled = false
                    self.animationCount = 0
                    self.playButtonImageView.isHidden = false
                    return
                }
                
                guard self.animationCount == self.animationTotal else {
                    self.animatePlayButton(completion)
                    return
                }
                
                self.animationEnabled = false
                self.animationCount = 0
                self.playButtonImageView.isHidden = false
                
                // The last completion
                completion?()
            }
        )
    }
    
    // MARK: Status bar
    
    fileprivate var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    // MARK: State
    
    fileprivate enum State {
        case mine
        case online
    }
    
    fileprivate var state: State = .online {
        didSet {
            switch state {
            case .mine:
                backgroundView.bringSubview(toFront: mineViewController.view)
                
                let mineImage = mineButtonImageView.image?.image(withColor: UIColor.white)
                let onlineImage = onlineButtonImageView.image?.image(withColor: ColorConstants.toolbarImage)
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = UIColor.white
                onlineButtonLabel.textColor = ColorConstants.text
                
                mineButtonBackgroundView.backgroundColor = ColorConstants.main
                onlineButtonBackgroundView.backgroundColor = ColorConstants.toolbarNormalBackground
            case .online:
                backgroundView.bringSubview(toFront: onlineViewController.view)
                
                let mineImage = mineButtonImageView.image?.image(withColor: ColorConstants.toolbarImage)
                let onlineImage = onlineButtonImageView.image?.image(withColor: UIColor.white)
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = ColorConstants.text
                onlineButtonLabel.textColor = UIColor.white
                
                mineButtonBackgroundView.backgroundColor = ColorConstants.toolbarNormalBackground
                onlineButtonBackgroundView.backgroundColor = ColorConstants.main
            }
        }
    }

}

// MARK: PlayerViewControllerDelegate

extension HomeViewController: PlayerViewControllerDelegate {
    
    func playerViewController(_ controller: PlayerViewController, didRecognizeByPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer, completion: (() -> Void)? = nil) {
        guard playerViewController.isMiddleViewOfScrollView() else { return }
        
        let offsetY = gestureRecognizer.translation(in: self.view).y
        guard offsetY > 0 else { return }
        
        let height = self.view.bounds.size.height
        
        switch gestureRecognizer.state {
        case .changed:
            setPropertiesForChangedState(atOffsetY: offsetY, forDirection: .fromTopToBottom)
        case .ended:
            if offsetY < height / 2 {
                UIView.animate(
                    withDuration: transitionDuration,
                    animations: {
                        self.setPropertiesForEndedState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .lightContent
                        completion?()
                    }
                )
            } else if offsetY < height {
                UIView.animate(
                    withDuration: transitionDuration,
                    animations: {
                        self.setPropertiesForBeganState()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.statusBarStyle = .default
                        completion?()
                    }
                )
            }
        default:
            break
        }
    }
    
    func dismiss(playerViewController controller: PlayerViewController, completion: (() -> Void)?) {
        UIView.animate(
            withDuration: transitionDuration,
            animations: {
                self.setPropertiesForBeganState()
            },
            completion: { completed in
                guard completed else { return }
                self.statusBarStyle = .default
                completion?()
            }
        )
    }
    
}
