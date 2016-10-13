//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/19/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol PlayerViewControllerDelegate {
    
    func playerViewController(_ controller: PlayerViewController, didRecognizeByPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer, completion: (() -> Void)?)
    func dismiss(playerViewController controller: PlayerViewController, completion: (() -> Void)?)
    
}

protocol PlayerChildViewControllerDelegate {
    
    var duration: Int { get }
    var currentTime: Int { get }
    
    func playerChildViewController(
        _ controller: PlayerChildViewController,
        options: PlayerChildViewControllerPanGestureRecognizerDirection?,
        didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer
    )
    
}

protocol PlayerChildViewController {
    
    var delegate: PlayerChildViewControllerDelegate? { get }
    
    func play()
    func pause()
    func moveForward()
    func moveBackward()
    
    var duration: Int { get }
    var currentTime: Int { get }
    
}

extension PlayerChildViewController {
    
    var duration: Int { get { return self.delegate?.duration ?? 0 } }
    var currentTime: Int { get { return self.delegate?.currentTime ?? 0 } }
    
}

// MARK: PlayerChildViewControllerPanGestureRecognizerDirection

struct PlayerChildViewControllerPanGestureRecognizerDirection: OptionSet {
    
    static let left     = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 1)
    static let right    = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 2)
    static let top      = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 4)
    static let bottom   = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 8)
    
    static let all: PlayerChildViewControllerPanGestureRecognizerDirection = [left, right, top, bottom]
    
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    
}

// MARK: Class PlayerViewController

class PlayerViewController: UIViewController {
    
    // MARK: - Models
    
    var duration: Int = 752
    
    var currentTime: Int = 175 {
        didSet {
            guard playedProgressBar != nil else { return }
            guard playedProgressBarWidthConstrant != nil else { return }
            guard sliderViewLeadingSpaceConstraint != nil else { return }
            
            currentTimeLabel?.text = Date.getStringFormatFromTime(currentTime)
            
            let multiplier = CGFloat(Float(currentTime) / Float(duration))
            
            self.view?.removeConstraint(playedProgressBarWidthConstrant)
            playedProgressBarWidthConstrant = NSLayoutConstraint(
                item: playedProgressBar,
                attribute: .width,
                relatedBy: .equal,
                toItem: progressBar,
                attribute: .width,
                multiplier: multiplier,
                constant: 0
            )
            self.view?.addConstraint(playedProgressBarWidthConstrant)
            
            sliderViewLeadingSpaceConstraint?.constant = (progressBar.frame.size.width - sliderView.frame.size.width) * multiplier
        }
    }
    
    var backgroundImage: UIImage = UIImage(named: "background")!
    
    // MARK: Public APIs
    
    func selectedIndexOfScrollView() -> Int {
        switch position {
        case .left: return 0
        case .middle: return 1
        case .right: return 2
        case .transitioning: return -1
        }
    }
    
    func isMiddleViewOfScrollView() -> Bool {
        return position == .middle
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var dismissButton: CircleButton!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet fileprivate weak var leftView: UIView!
    @IBOutlet fileprivate weak var middleView: UIView!
    @IBOutlet fileprivate weak var rightView: UIView!
    
    @IBOutlet weak var leftViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: CircleButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var unloadProgressBar: UIView!
    @IBOutlet weak var playedProgressBar: UIView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var sliderViewLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var playedProgressBarWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var unloadProgressBarWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backwardButtonLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var forwardButtonTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func dismissButtonTapped() {
        self.delegate?.dismiss(playerViewController: self) {
            self.animationVerticalEnabled = nil
        }
    }
    
    @IBAction func playPauseButtonTapped(_ button: UIButton) {
        playerChildViewControllers.forEach { $0.play() }
    }
    
    @IBAction func backwardButtonTapped() {
        playerChildViewControllers.forEach { $0.moveBackward() }
    }
    
    @IBAction func forwardButtonTapped() {
        playerChildViewControllers.forEach { $0.moveForward() }
    }
    
    // MARK: Delegation
    
    var delegate: PlayerViewControllerDelegate?
    
    // MARK: Private properties
    
    fileprivate var audioPlayer: AudioPlayer = OnlineAudioPlayer()
    
    fileprivate var animationDuration: TimeInterval = 0.35
    fileprivate var animationVerticalEnabled: Bool?
    
    fileprivate let swipeVelocityX: CGFloat = 950
    fileprivate let swipeTimeoutDuration: TimeInterval = 0.4
    fileprivate var swipeTimeoutTimer: Timer?
    
    fileprivate var startAlpha: CGFloat = 0.2
    fileprivate var endAlpha: CGFloat = 1.0
    fileprivate lazy var scaleAlphaFactor: CGFloat = self.endAlpha - self.startAlpha
    
    fileprivate var oldSliderViewConstant: CGFloat = 0
    
    fileprivate var unloadProgressBarWidthConstant: CGFloat {
        return self.progressBar.frame.size.width - self.unloadProgressBar.frame.size.width
    }
    
    fileprivate var tooltip = TooltipView.sharedTooltipView
    fileprivate var marginTooltipConstraint: NSLayoutConstraint!
    fileprivate var verticalTooltipConstraint: NSLayoutConstraint!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer.dataSource = AudioPlayerDefaultDataSource()
        audioPlayer.delegate = self
        
        // 238DFF
        pageControl.currentPageIndicatorTintColor = UIColor(red: 35/255, green: 141/255, blue: 1, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDetails()
        setupProgressBar()
        setupButtons()
    }
    
    // MARK: Initialization and Configuration
    
    fileprivate func setupDetails() {
        self.display(contentController: listPlayerViewController, in: leftView)
        self.display(contentController: singlePlayerViewController, in: middleView)
        self.display(contentController: lyricPlayerViewController, in: rightView)
 
        self.setAlphaFor(leftView: self.endAlpha, middleView: self.startAlpha, rightView: self.startAlpha)
        
        let width = self.view.bounds.size.width
        self.setConstantOfCenterXConstraintFor(leftView: 0, middleView: width, rightView: 2 * width)
    }
    
    fileprivate func setupProgressBar() {
        if duration <= 0 {
            duration = 1
            currentTime = 0
        }
        
        if currentTime < 0 {
            currentTime = 0
        }
        
        if currentTime > duration {
            currentTime = duration
        }
        
        sliderView.layer.cornerRadius = sliderView.bounds.size.height / 2
        sliderView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didRecognizeByGestureForSlider(_:))))

        durationLabel.text = Date.getStringFormatFromTime(duration)
        
        // Call the observer of currentTime
        currentTime = currentTime - 1 + 1
    }
    
    fileprivate func setupButtons() {
        let dismissColor = UIColor.white.withAlphaComponent(0.7)
        dismissButton.backgroundColor = UIColor.clear
        dismissButton.image = UIImage(named: "BottomArrow")?.image(withColor: dismissColor)
        dismissButton.circleColor = dismissColor
        dismissButton.borderWidth = 1
        dismissButton.type = .inner
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), forEvent: .touchUpInside)
        
        let playImage = UIImage(named: "Play")
        self.playButton.image = playImage?.image(withColor: UIColor.white)
        self.playButton.scale = 0.65
        self.playButton.borderWidth = 2
        self.playButton.circleColor = UIColor.white.withAlphaComponent(0.5)
        self.playButton.type = .border
        
        let backImage = self.backwardButton.image(for: .normal)?.image(withColor: UIColor.white)
        let forwardImage = self.forwardButton.image(for: .normal)?.image(withColor: UIColor.white)
        
        self.backwardButton.setImage(backImage, for: .normal)
        self.forwardButton.setImage(forwardImage, for: .normal)
        
        let width = self.view.bounds.size.width
        let buttonWidth = self.backwardButton.frame.size.width
        backwardButtonLeadingSpaceConstraint.constant = width / 4 - buttonWidth
        forwardButtonTrailingConstraint.constant = -width / 4 + buttonWidth
    }
    
    // MARK: Child View Controllers
    
    fileprivate lazy var listPlayerViewController: ListPlayerViewController = {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ControllersIdentifiers.listPlayer) as! ListPlayerViewController
        controller.delegate = self
        return controller
    }()
    
    fileprivate lazy var singlePlayerViewController: SinglePlayerViewController = {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ControllersIdentifiers.singlePlayer) as! SinglePlayerViewController
        controller.delegate = self
        return controller
    }()
    
    
    fileprivate lazy var lyricPlayerViewController: LyricPlayerViewController = {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: ControllersIdentifiers.lyricPlayer) as! LyricPlayerViewController
        controller.delegate = self
        return controller
    }()
    
    fileprivate lazy var playerChildViewControllers: [PlayerChildViewController] = [
        self.listPlayerViewController, self.singlePlayerViewController, self.lyricPlayerViewController
    ]
    
    // MARK: Change Detail Player Subviews
    
    fileprivate func changeChildPlayerView(fromPosition: Position, toPosition: Position, completion: (() -> Void)? = nil) {
        if (fromPosition == .left && toPosition == .right) || (fromPosition == .right && toPosition == .left) {
            return
        }
        
        UIView.animate(
            withDuration: animationDuration, delay: 0, options: .curveEaseIn,
            animations: {
                switch toPosition {
                case .left:     self.position = .left
                case .middle:   self.position = .middle
                case .right:    self.position = .right
                default: break
                }
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                guard completed else { return }
                completion?()
            }
        )
    }
    
    // MARK: Detail Player View Position
    
    fileprivate enum Position: Int {
        case left           = 0
        case middle         = 1
        case right          = 2
        case transitioning  = 3
        
        fileprivate static func isInvalidTransition(fromPosition: Position, toPosition: Position) -> Bool {
            return fromPosition == .transitioning || toPosition == .transitioning ||
                abs(fromPosition.rawValue - toPosition.rawValue) == 2
        }
    }
    
    fileprivate var position: Position = .left {
        didSet {
            let width = self.view.bounds.size.width
            switch position {
            case .left:
                self.setConstantOfCenterXConstraintFor(leftView: 0, middleView: width, rightView: 2 * width)
                self.setAlphaFor(leftView: self.endAlpha, middleView: self.startAlpha, rightView: self.startAlpha)
                self.topVisualEffectView.alpha = 1
            case .middle:
                self.setConstantOfCenterXConstraintFor(leftView: -width, middleView: 0, rightView: width)
                self.setAlphaFor(leftView: self.startAlpha, middleView: self.endAlpha, rightView: self.startAlpha)
                self.topVisualEffectView.alpha = 0
            case .right:
                self.setConstantOfCenterXConstraintFor(leftView: -2 * width, middleView: -width, rightView: 0)
                self.setAlphaFor(leftView: self.startAlpha, middleView: self.startAlpha, rightView: self.endAlpha)
                self.topVisualEffectView.alpha = 1
            default: break
            }
        }
    }
    
    // MARK: Swipe Gesture Recognizer - Timeout
    
    func swipeTimeoutTimerForSwipeGestureRecognizer(_ timer: Timer) {
        guard timer === swipeTimeoutTimer else { return }
        swipeTimeoutTimer?.invalidate()
        swipeTimeoutTimer = nil
    }
    
    // MARK: Internal struct Date - An helper structure
    
    fileprivate struct Date {
        
        static func getHourFromTime(_ time: Int) -> Int {
            return time / 60 / 60
        }
        
        static func getMinuteFromTime(_ time: Int) -> Int {
            return time / 60 % 60
        }
        
        static func getSecondFromTime(_ time: Int) -> Int {
            return time % 60
        }
        
        static func getStringFormatFromTime(_ time: Int) -> String {
            let minute = Date.getMinuteFromTime(time)
            let second = Date.getSecondFromTime(time)
            return String(format: "%02d:%02d", minute, second)
        }
        
    }

}

// MARK: PlayerChildViewControllerDelegate

extension PlayerViewController: PlayerChildViewControllerDelegate {
    
    func playerChildViewController(_ controller: PlayerChildViewController, options: PlayerChildViewControllerPanGestureRecognizerDirection?, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        guard let options = options else { return }
        
        if let controller = controller as? ListPlayerViewController , !options.isEmpty && options.isSubset(of: PlayerChildViewControllerPanGestureRecognizerDirection.left) {
            self.listPlayerViewController(controller, didRecognizeByPanGestureRecognizer: panGestureRecognizer)
        }
        
        if let controller = controller as? SinglePlayerViewController , PlayerChildViewControllerPanGestureRecognizerDirection.all.subtracting(options).isEmpty {
            self.singlePlayerViewController(controller, didRecognizeByPanGestureRecognizer: panGestureRecognizer)
        }
        if let controller = controller as? LyricPlayerViewController , !options.isEmpty && options.isSubset(of: PlayerChildViewControllerPanGestureRecognizerDirection.right) {
            self.lyricPlayerViewController(controller, didRecognizeByPanGestureRecognizer: panGestureRecognizer)
        }
    }
    
    fileprivate func listPlayerViewController(_ controller: ListPlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        // Swipe Gesture
        if swipeTimeoutTimer != nil && panGestureRecognizer.velocity(in: self.view).x < -swipeVelocityX {
            panGestureRecognizer.isEnabled = false
            self.changeChildPlayerView(fromPosition: .left, toPosition: .middle) {
                self.setPropertiesForEndedState(fromPosition: .left, toPosition: self.position)
                panGestureRecognizer.isEnabled = true
            }
            return
        }
        
        // Pan Gesture
        let offsetX = panGestureRecognizer.translation(in: self.view).x
        guard offsetX < 0 else { return }
        
        switch panGestureRecognizer.state {
        case .possible where swipeTimeoutTimer == nil, .began where swipeTimeoutTimer == nil:
            swipeTimeoutTimer = Timer.scheduledTimer(
                timeInterval: swipeTimeoutDuration,
                target: self,
                selector: #selector(swipeTimeoutTimerForSwipeGestureRecognizer(_:)),
                userInfo: nil,
                repeats: false
            )
        case .changed:
            self.setPropertiesForChangedState(fromPosition: .left, toPosition: .middle, byOffsetX: -offsetX)
        case .ended:
            if -offsetX < self.view.bounds.size.width / 2 {
                UIView.animate(
                    withDuration: animationDuration,
                    animations: {
                        self.position = .left
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedState(atPosition: .left)
                    }
                )
            } else {
                UIView.animate(
                    withDuration: animationDuration,
                    animations: {
                        self.position = .middle
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedState(fromPosition: .left, toPosition: .middle)
                    }
                )
            }
        default:
            break
        }
    }
    
    fileprivate func singlePlayerViewController(_ controller: SinglePlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        
        func moveVertically() {
            self.delegate?.playerViewController(self, didRecognizeByPanGestureRecognizer: panGestureRecognizer) {
                self.animationVerticalEnabled = nil
            }
        }
        
        func moveHorizontally() {
            // Swipe Gesture
            let velocityX = panGestureRecognizer.velocity(in: self.view).x
            
            if swipeTimeoutTimer != nil && velocityX > swipeVelocityX {
                panGestureRecognizer.isEnabled = false
                self.changeChildPlayerView(fromPosition: .middle, toPosition: .left) {
                    self.setPropertiesForEndedState(fromPosition: .middle, toPosition: self.position)
                    panGestureRecognizer.isEnabled = true
                    self.animationVerticalEnabled = nil
                }
                return
            } else if swipeTimeoutTimer != nil && velocityX < -swipeVelocityX {
                panGestureRecognizer.isEnabled = false
                self.changeChildPlayerView(fromPosition: .middle, toPosition: .right) {
                    self.setPropertiesForEndedState(fromPosition: .middle, toPosition: self.position)
                    panGestureRecognizer.isEnabled = true
                    self.animationVerticalEnabled = nil
                }
                return
            }
            
            // Pan Gesture
            let offsetX = translation.x
            
            if offsetX < 0 {
                switch panGestureRecognizer.state {
                case .possible where swipeTimeoutTimer == nil, .began where swipeTimeoutTimer == nil:
                    swipeTimeoutTimer = Timer.scheduledTimer(
                        timeInterval: swipeTimeoutDuration,
                        target: self,
                        selector: #selector(swipeTimeoutTimerForSwipeGestureRecognizer(_:)),
                        userInfo: nil,
                        repeats: false
                    )
                case .changed:
                    self.setPropertiesForChangedState(fromPosition: .middle, toPosition: .right, byOffsetX: -offsetX)
                case .ended:
                    if -offsetX < self.view.bounds.size.width / 2 {
                        UIView.animate(
                            withDuration: animationDuration,
                            animations: {
                                self.position = .middle
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedState(atPosition: .middle)
                            }
                        )
                    } else {
                        UIView.animate(
                            withDuration: animationDuration,
                            animations: {
                                self.position = .right
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedState(fromPosition: .middle, toPosition: .right)
                            }
                        )
                    }
                default:
                    break
                }
            } else if offsetX > 0 {
                switch panGestureRecognizer.state {
                case .possible where swipeTimeoutTimer == nil, .began where swipeTimeoutTimer == nil:
                    swipeTimeoutTimer = Timer.scheduledTimer(
                        timeInterval: swipeTimeoutDuration,
                        target: self,
                        selector: #selector(swipeTimeoutTimerForSwipeGestureRecognizer(_:)),
                        userInfo: nil,
                        repeats: false
                    )
                case .changed:
                    self.setPropertiesForChangedState(fromPosition: .middle, toPosition: .left, byOffsetX: offsetX)
                case .ended:
                    if offsetX < self.view.bounds.size.width / 2 {
                        UIView.animate(
                            withDuration: animationDuration,
                            animations: {
                                self.position = .middle
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedState(atPosition: .middle)
                            }
                        )
                    } else {
                        UIView.animate(
                            withDuration: animationDuration,
                            animations: {
                                self.position = .left
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedState(fromPosition: .middle, toPosition: .left)
                            }
                        )
                    }
                default:
                    break
                }
            }
        }
        
        if panGestureRecognizer.state == .changed && animationVerticalEnabled == nil {
            animationVerticalEnabled = abs(translation.y) > abs(translation.x)
        }
        
        if animationVerticalEnabled == false {
            moveHorizontally()
        } else if animationVerticalEnabled == true {
            moveVertically()
        }
    }
    
    fileprivate func lyricPlayerViewController(_ controller: LyricPlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        // Swipe Gesture
        if swipeTimeoutTimer != nil && panGestureRecognizer.velocity(in: self.view).x > swipeVelocityX {
            panGestureRecognizer.isEnabled = false
            self.changeChildPlayerView(fromPosition: .right, toPosition: .middle) {
                self.setPropertiesForEndedState(fromPosition: .right, toPosition: self.position)
                panGestureRecognizer.isEnabled = true
            }
            return
        }
        
        // Pan Gesture
        let offsetX = panGestureRecognizer.translation(in: self.view).x
        guard offsetX > 0 else { return }
        
        switch panGestureRecognizer.state {
        case .possible where swipeTimeoutTimer == nil, .began where swipeTimeoutTimer == nil:
            swipeTimeoutTimer = Timer.scheduledTimer(
                timeInterval: swipeTimeoutDuration,
                target: self,
                selector: #selector(swipeTimeoutTimerForSwipeGestureRecognizer(_:)),
                userInfo: nil,
                repeats: false
            )
        case .changed:
            self.setPropertiesForChangedState(fromPosition: .right, toPosition: .middle, byOffsetX: offsetX)
        case .ended:
            if offsetX < self.view.bounds.size.width / 2 {
                UIView.animate(
                    withDuration: animationDuration,
                    animations: {
                        self.position = .right
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedState(atPosition: .right)
                    }
                )
            } else {
                UIView.animate(
                    withDuration: animationDuration,
                    animations: {
                        self.position = .middle
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedState(fromPosition: .right, toPosition: .middle)
                    }
                )
            }
        default:
            break
        }
    }
    
    fileprivate func setPropertiesForChangedState(fromPosition: Position, toPosition: Position, byOffsetX offsetX: CGFloat) {
        if Position.isInvalidTransition(fromPosition: fromPosition, toPosition: toPosition) { return }
        
        let width = self.view.bounds.size.width
        let multiplier = offsetX / width
        let alphaDuration = self.scaleAlphaFactor * multiplier
        
        func setPropertiesForChangedStateFromLeftToMiddle() {
            self.setConstantOfCenterXConstraintFor(leftView: -offsetX, middleView: width - offsetX, rightView: 2 * width - offsetX)
            self.setAlphaFor(leftView: self.endAlpha - alphaDuration, middleView: self.startAlpha + alphaDuration, rightView: self.startAlpha)
            self.topVisualEffectView.alpha = 1.0 - multiplier
        }
        
        func setPropertiesForChangedStateFromMiddleToLeft() {
            self.setConstantOfCenterXConstraintFor(leftView: -width + offsetX, middleView: offsetX, rightView: width + offsetX)
            self.setAlphaFor(leftView: self.startAlpha + alphaDuration, middleView: self.endAlpha - alphaDuration, rightView: self.startAlpha)
            self.topVisualEffectView.alpha = multiplier
        }
        
        func setPropertiesForChangedStateFromMiddleToRight() {
            self.setConstantOfCenterXConstraintFor(leftView: -width - offsetX, middleView: -offsetX, rightView: width - offsetX)
            self.setAlphaFor(leftView: self.startAlpha, middleView: self.endAlpha - alphaDuration, rightView: self.startAlpha + alphaDuration)
            self.topVisualEffectView.alpha = multiplier
        }
        
        func setPropertiesForChangedStateFromRightToMiddle() {
            self.setConstantOfCenterXConstraintFor(leftView: -2 * width + offsetX, middleView: -width + offsetX, rightView: offsetX)
            self.setAlphaFor(leftView: self.startAlpha, middleView: self.startAlpha + alphaDuration, rightView: self.endAlpha - alphaDuration)
            self.topVisualEffectView.alpha = 1.0 - multiplier
        }
        
        switch fromPosition {
        case .left      where toPosition == .middle:    setPropertiesForChangedStateFromLeftToMiddle()
        case .middle    where toPosition == .left:      setPropertiesForChangedStateFromMiddleToLeft()
        case .middle    where toPosition == .right:     setPropertiesForChangedStateFromMiddleToRight()
        case .right     where toPosition == .middle:    setPropertiesForChangedStateFromRightToMiddle()
        default: break
        }
    }
    
    fileprivate func setPropertiesForEndedState(fromPosition: Position, toPosition: Position) {
        if Position.isInvalidTransition(fromPosition: fromPosition, toPosition: toPosition) { return }
        
        if fromPosition == toPosition {
            self.setPropertiesForEndedState(atPosition: toPosition)
            return
        }
        
        if fromPosition == .right {
            lyricPlayerViewController.stopTimer()
        } else if toPosition == .right {
            lyricPlayerViewController.startTimer()
        }
        
        self.setPropertiesForEndedState(atPosition: toPosition)
    }
    
    fileprivate func setPropertiesForEndedState(atPosition position: Position) {
        if Position.isInvalidTransition(fromPosition: position, toPosition: position) { return }
        
        switch position {
        case .left:     self.pageControl.currentPage = 0
        case .middle:   self.pageControl.currentPage = 1
        case .right:    self.pageControl.currentPage = 2
        default: break
        }
    }
    
    fileprivate func setConstantOfCenterXConstraintFor(leftView leftConstant: CGFloat, middleView middleConstant: CGFloat, rightView rightConstant: CGFloat) {
        self.leftViewCenterXConstraint.constant     = leftConstant
        self.middleViewCenterXConstraint.constant   = middleConstant
        self.rightViewCenterXConstraint.constant    = rightConstant
    }
    
    fileprivate func setAlphaFor(leftView leftAlpha: CGFloat, middleView middleAlpha: CGFloat, rightView rightAlpha: CGFloat) {
        self.leftView.alpha     = leftAlpha
        self.middleView.alpha   = middleAlpha
        self.rightView.alpha    = rightAlpha
    }
    
}

// MARK: Gesture Recognizer

extension PlayerViewController {
    
    func didRecognizeByGestureForSlider(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        func updateProgressBarWithConstant(_ constant: CGFloat) {
            let multiplier = constant / self.progressBar.frame.size.width
            self.view.removeConstraint(playedProgressBarWidthConstrant)
            playedProgressBarWidthConstrant = NSLayoutConstraint(
                item: playedProgressBar,
                attribute: .width,
                relatedBy: .equal,
                toItem: progressBar,
                attribute: .width,
                multiplier: multiplier,
                constant: 0
            )
            self.view.addConstraint(playedProgressBarWidthConstrant)
            
            self.sliderViewLeadingSpaceConstraint.constant = constant
        }
        
        func changeLeadingSpaceConstraint() {
            let newPosition = self.sliderViewLeadingSpaceConstraint.constant + panGestureRecognizer.translation(in: self.sliderView).x
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self.sliderView)
            
            if newPosition < 0 || newPosition > self.progressBar.frame.size.width - self.sliderView.frame.size.width {
                return
            }
            
            updateProgressBarWithConstant(newPosition)
        }
        
        func getTimeFormaterFromSliderViewConstraint() -> String {
            let currentTime = Int(CGFloat(duration) * sliderViewLeadingSpaceConstraint.constant / (progressBar.frame.size.width - sliderView.frame.size.width))
            return Date.getStringFormatFromTime(currentTime)
        }
        
        func getTooltip() {
            let image = UIImage.image(withColor: UIColor.black, withSize: self.sliderView.frame.size)
            self.tooltip.backgroundImageView.image = image.image(withRadius: self.sliderView.frame.size.height / 2)
            
            marginTooltipConstraint = NSLayoutConstraint(
                item: self.sliderView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self.tooltip,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            )
            
            verticalTooltipConstraint = NSLayoutConstraint(
                item: self.sliderView,
                attribute: .top,
                relatedBy: .equal,
                toItem: self.tooltip,
                attribute: .bottom,
                multiplier: 1,
                constant: 0.2 * self.sliderView.frame.size.height
            )
            
            self.view.addConstraints([marginTooltipConstraint, verticalTooltipConstraint])
            self.view.layoutIfNeeded()
        }
        
        func removeTooltip() {
            self.view.removeConstraints([marginTooltipConstraint, verticalTooltipConstraint])
            marginTooltipConstraint = nil
            verticalTooltipConstraint = nil
        }
        
        switch panGestureRecognizer.state {
        case .began:
            changeLeadingSpaceConstraint()
            oldSliderViewConstant = self.sliderViewLeadingSpaceConstraint.constant
            
            let currentTimeFormatter = Date.getStringFormatFromTime(currentTime)
            currentTimeLabel.text = currentTimeFormatter
            tooltip.title = currentTimeFormatter
            
            self.view.addSubview(tooltip)
            getTooltip()
        case .changed:
            changeLeadingSpaceConstraint()
            
            let currentTimeFormatter = getTimeFormaterFromSliderViewConstraint()
            currentTimeLabel.text = currentTimeFormatter
            tooltip.title = currentTimeFormatter
        case .ended:
            changeLeadingSpaceConstraint()
            
            if self.sliderViewLeadingSpaceConstraint.constant > unloadProgressBarWidthConstant {
                updateProgressBarWithConstant(oldSliderViewConstant)
                currentTimeLabel.text = getTimeFormaterFromSliderViewConstraint()
                
                removeTooltip()
                tooltip.removeFromSuperview()
                
                return
            }
            
            currentTime = Int(CGFloat(duration) * sliderViewLeadingSpaceConstraint.constant / (progressBar.frame.size.width - sliderView.frame.size.width))
            removeTooltip()
            tooltip.removeFromSuperview()
        case .cancelled:
            changeLeadingSpaceConstraint()
            currentTimeLabel.text = getTimeFormaterFromSliderViewConstraint()
            
            removeTooltip()
            tooltip.removeFromSuperview()
        default:
            break
        }
    }
    
}

// MARK: Audio Player Delegate

extension PlayerViewController: AudioPlayerDelegate {
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didSelectAtIndex: Int) {
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willTransitionFromIndex fromIndex: Int, toIndex: Int) {
        
    }
    
}
