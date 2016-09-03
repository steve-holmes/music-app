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
    
    func playerViewController(controller: PlayerViewController, didRecognizeByPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer, completion: (() -> Void)?)
    func dismissPlayerViewController(controller: PlayerViewController, completion: (() -> Void)?)
    
}

protocol PlayerChildViewControllerDelegate {
    
    func playerChildViewController(
        controller: PlayerChildViewController,
        options: PlayerChildViewControllerPanGestureRecognizerDirection?,
        didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer
    )
    
}

protocol PlayerChildViewController {
    
    var delegate: PlayerChildViewControllerDelegate? { get }
    
}

// MARK: PlayerChildViewControllerPanGestureRecognizerDirection

struct PlayerChildViewControllerPanGestureRecognizerDirection: OptionSetType {
    
    static let Left     = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 1)
    static let Right    = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 2)
    static let Top      = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 4)
    static let Bottom   = PlayerChildViewControllerPanGestureRecognizerDirection(rawValue: 8)
    
    static let All: PlayerChildViewControllerPanGestureRecognizerDirection = [Left, Right, Top, Bottom]
    
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
                attribute: .Width,
                relatedBy: .Equal,
                toItem: progressBar,
                attribute: .Width,
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
        case .Left: return 0
        case .Middle: return 1
        case .Right: return 2
        }
    }
    
    func isMiddleViewOfScrollView() -> Bool {
        return position == .Middle
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet private weak var leftView: UIView!
    @IBOutlet private weak var middleView: UIView!
    @IBOutlet private weak var rightView: UIView!
    
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
        self.delegate?.dismissPlayerViewController(self) {
            self.animationVerticalEnabled = nil
        }
    }
    
    @IBAction func playPauseButtonTapped(button: UIButton) {
        print(#function)
    }
    
    @IBAction func backwardButtonTapped() {
        print(#function)
    }
    
    @IBAction func forwardButtonTapped() {
        print(#function)
    }
    
    // MARK: Delegation
    
    var delegate: PlayerViewControllerDelegate?
    
    // MARK: Private properties
    
    private var animationDuration: NSTimeInterval = 0.35
    private var animationVerticalEnabled: Bool?
    
    private let swipeVelocityX: CGFloat = 1100
    
    private var startAlpha: CGFloat = 0.2
    private var endAlpha: CGFloat = 1.0
    private lazy var scaleAlphaFactor: CGFloat = self.endAlpha - self.startAlpha
    
    private var oldSliderViewConstant: CGFloat = 0
    
    private var unloadProgressBarWidthConstant: CGFloat {
        return self.progressBar.frame.size.width - self.unloadProgressBar.frame.size.width
    }
    
    private var tooltip = TooltipView.sharedTooltipView
    private var marginTooltipConstraint: NSLayoutConstraint!
    private var verticalTooltipConstraint: NSLayoutConstraint!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 238DFF
        pageControl.currentPageIndicatorTintColor = UIColor(red: 35/255, green: 141/255, blue: 1, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        
        setupDetails()
        setupProgressBar()
        setupButtons()
    }
    
    // MARK: Initialization and Configuration
    
    private func setupDetails() {
        self.displayContentController(listPlayerViewController, inView: leftView)
        self.displayContentController(singlePlayerViewController, inView: middleView)
        self.displayContentController(lyricPlayerViewController, inView: rightView)
 
        self.setAlphaForLeftView(self.endAlpha, middleView: self.startAlpha, rightView: self.startAlpha)
        
        let width = self.view.bounds.size.width
        self.setConstantOfCenterXConstraintForLeftView(0, middleView: width, rightView: 2 * width)
    }
    
    private func setupProgressBar() {
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
    
    private func setupButtons() {
        self.playButton.circleWidth = 2
        self.playButton.circleColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        let backImage = self.backwardButton.imageForState(.Normal)?.imageWithColor(UIColor.whiteColor())
        let forwardImage = self.forwardButton.imageForState(.Normal)?.imageWithColor(UIColor.whiteColor())
        
        self.backwardButton.setImage(backImage, forState: .Normal)
        self.forwardButton.setImage(forwardImage, forState: .Normal)
        
        let width = self.view.bounds.size.width
        let buttonWidth = self.backwardButton.frame.size.width
        backwardButtonLeadingSpaceConstraint.constant = width / 4 - buttonWidth
        forwardButtonTrailingConstraint.constant = -width / 4 + buttonWidth
    }
    
    // MARK: Child View Controllers
    
    private lazy var listPlayerViewController: ListPlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.ListPlayerController) as! ListPlayerViewController
        controller.delegate = self
        return controller
    }()
    
    private lazy var singlePlayerViewController: SinglePlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.SinglePlayerController) as! SinglePlayerViewController
        controller.delegate = self
        return controller
    }()
    
    
    private lazy var lyricPlayerViewController: LyricPlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.LyricPlayerController) as! LyricPlayerViewController
        controller.delegate = self
        return controller
    }()
    
    // MARK: Change Detail Player Subviews
    
    private func changeChildPlayerViewFromPosition(fromPosition: Position, toPosition: Position, completion: (() -> Void)? = nil) {
        if (fromPosition == .Left && toPosition == .Right) || (fromPosition == .Right && toPosition == .Left) {
            return
        }
        
        UIView.animateWithDuration(
            animationDuration, delay: 0, options: .CurveEaseIn,
            animations: {
                switch toPosition {
                case .Left:     self.position = .Left
                case .Middle:   self.position = .Middle
                case .Right:    self.position = .Right
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
    
    private enum Position {
        case Left
        case Middle
        case Right
    }
    
    private var position: Position = .Left {
        didSet {
            let width = self.view.bounds.size.width
            switch position {
            case .Left:
                self.setConstantOfCenterXConstraintForLeftView(0, middleView: width, rightView: 2 * width)
                self.setAlphaForLeftView(self.endAlpha, middleView: self.startAlpha, rightView: self.startAlpha)
                self.topVisualEffectView.alpha = 1
            case .Middle:
                self.setConstantOfCenterXConstraintForLeftView(-width, middleView: 0, rightView: width)
                self.setAlphaForLeftView(self.startAlpha, middleView: self.endAlpha, rightView: self.startAlpha)
                self.topVisualEffectView.alpha = 0
            case .Right:
                self.setConstantOfCenterXConstraintForLeftView(-2 * width, middleView: -width, rightView: 0)
                self.setAlphaForLeftView(self.startAlpha, middleView: self.startAlpha, rightView: self.endAlpha)
                self.topVisualEffectView.alpha = 1
            }
        }
    }
    
    // MARK: Internal struct Date - An helper structure
    
    private struct Date {
        
        static func getHourFromTime(time: Int) -> Int {
            return time / 60 / 60
        }
        
        static func getMinuteFromTime(time: Int) -> Int {
            return time / 60 % 60
        }
        
        static func getSecondFromTime(time: Int) -> Int {
            return time % 60
        }
        
        static func getStringFormatFromTime(time: Int) -> String {
            let minute = Date.getMinuteFromTime(time)
            let second = Date.getSecondFromTime(time)
            return String(format: "%02d:%02d", minute, second)
        }
        
    }

}

// MARK: PlayerChildViewControllerDelegate

extension PlayerViewController: PlayerChildViewControllerDelegate {
    
    func playerChildViewController(controller: PlayerChildViewController, options: PlayerChildViewControllerPanGestureRecognizerDirection?, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        guard let options = options else { return }
        
        if let controller = controller as? ListPlayerViewController where !options.isEmpty && options.isSubsetOf(PlayerChildViewControllerPanGestureRecognizerDirection.Left) {
            self.listPlayerViewController(controller, didRecognizeByPanGestureRecognizer: panGestureRecognizer)
        }
        
        if let controller = controller as? SinglePlayerViewController where PlayerChildViewControllerPanGestureRecognizerDirection.All.subtract(options).isEmpty {
            self.singlePlayerViewController(controller, didRecognizeByPanGestureRecognizer: panGestureRecognizer)
        }
        if let controller = controller as? LyricPlayerViewController where !options.isEmpty && options.isSubsetOf(PlayerChildViewControllerPanGestureRecognizerDirection.Right) {
            self.lyricPlayerViewController(controller, didRecognizeByPanGestureRecognizer: panGestureRecognizer)
        }
    }
    
    private func listPlayerViewController(controller: ListPlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        // Swipe Gesture
        if panGestureRecognizer.velocityInView(self.view).x < -swipeVelocityX {
            panGestureRecognizer.enabled = false
            self.changeChildPlayerViewFromPosition(.Left, toPosition: .Middle) {
                self.setPropertiesForEndedStateAtPosition(self.position)
                panGestureRecognizer.enabled = true
            }
            return
        }
        
        // Pan Gesture
        let offsetX = panGestureRecognizer.translationInView(self.view).x
        guard offsetX < 0 else { return }
        
        switch panGestureRecognizer.state {
        case .Changed:
            self.setPropertiesForChangedStateFromPosition(.Left, toPosition: .Middle, byOffsetX: -offsetX)
        case .Ended:
            if -offsetX < self.view.bounds.size.width / 2 {
                UIView.animateWithDuration(
                    animationDuration,
                    animations: {
                        self.position = .Left
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedStateAtPosition(.Left)
                    }
                )
            } else {
                UIView.animateWithDuration(
                    animationDuration,
                    animations: {
                        self.position = .Middle
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedStateAtPosition(.Middle)
                    }
                )
            }
        default:
            break
        }
    }
    
    private func singlePlayerViewController(controller: SinglePlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translationInView(self.view)
        
        func moveVertically() {
            self.delegate?.playerViewController(self, didRecognizeByPanGestureRecognizer: panGestureRecognizer) {
                self.animationVerticalEnabled = nil
            }
        }
        
        func moveHorizontally() {
            // Swipe Gesture
            let velocityX = panGestureRecognizer.velocityInView(self.view).x
            
            if velocityX > swipeVelocityX {
                panGestureRecognizer.enabled = false
                self.changeChildPlayerViewFromPosition(.Middle, toPosition: .Left) {
                    self.setPropertiesForEndedStateAtPosition(self.position)
                    panGestureRecognizer.enabled = true
                    self.animationVerticalEnabled = nil
                }
                return
            } else if velocityX < -swipeVelocityX {
                panGestureRecognizer.enabled = false
                self.changeChildPlayerViewFromPosition(.Middle, toPosition: .Right) {
                    self.setPropertiesForEndedStateAtPosition(self.position)
                    panGestureRecognizer.enabled = true
                    self.animationVerticalEnabled = nil
                }
                return
            }
            
            // Pan Gesture
            let offsetX = translation.x
            
            if offsetX < 0 {
                switch panGestureRecognizer.state {
                case .Changed:
                    self.setPropertiesForChangedStateFromPosition(.Middle, toPosition: .Right, byOffsetX: -offsetX)
                case .Ended:
                    if -offsetX < self.view.bounds.size.width / 2 {
                        UIView.animateWithDuration(
                            animationDuration,
                            animations: {
                                self.position = .Middle
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedStateAtPosition(.Middle)
                            }
                        )
                    } else {
                        UIView.animateWithDuration(
                            animationDuration,
                            animations: {
                                self.position = .Right
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedStateAtPosition(.Right)
                            }
                        )
                    }
                default:
                    break
                }
            } else if offsetX > 0 {
                switch panGestureRecognizer.state {
                case .Changed:
                    self.setPropertiesForChangedStateFromPosition(.Middle, toPosition: .Left, byOffsetX: offsetX)
                case .Ended:
                    if offsetX < self.view.bounds.size.width / 2 {
                        UIView.animateWithDuration(
                            animationDuration,
                            animations: {
                                self.position = .Middle
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedStateAtPosition(.Middle)
                            }
                        )
                    } else {
                        UIView.animateWithDuration(
                            animationDuration,
                            animations: {
                                self.position = .Left
                                self.view.layoutIfNeeded()
                            },
                            completion: { finished in
                                guard finished else { return }
                                self.animationVerticalEnabled = nil
                                self.setPropertiesForEndedStateAtPosition(.Left)
                            }
                        )
                    }
                default:
                    break
                }
            }
        }
        
        if panGestureRecognizer.state == .Changed && animationVerticalEnabled == nil {
            animationVerticalEnabled = abs(translation.y) > abs(translation.x)
        }
        
        if animationVerticalEnabled == false {
            moveHorizontally()
        } else if animationVerticalEnabled == true {
            moveVertically()
        }
    }
    
    private func lyricPlayerViewController(controller: LyricPlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        // Swipe Gesture
        if panGestureRecognizer.velocityInView(self.view).x > swipeVelocityX {
            panGestureRecognizer.enabled = false
            self.changeChildPlayerViewFromPosition(.Right, toPosition: .Middle) {
                self.setPropertiesForEndedStateAtPosition(self.position)
                panGestureRecognizer.enabled = true
            }
            return
        }
        
        // Pan Gesture
        let offsetX = panGestureRecognizer.translationInView(self.view).x
        guard offsetX > 0 else { return }
        
        switch panGestureRecognizer.state {
        case .Changed:
            self.setPropertiesForChangedStateFromPosition(.Right, toPosition: .Middle, byOffsetX: offsetX)
        case .Ended:
            if offsetX < self.view.bounds.size.width / 2 {
                UIView.animateWithDuration(
                    animationDuration,
                    animations: {
                        self.position = .Right
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedStateAtPosition(.Right)
                    }
                )
            } else {
                UIView.animateWithDuration(
                    animationDuration,
                    animations: {
                        self.position = .Middle
                        self.view.layoutIfNeeded()
                    },
                    completion: { finished in
                        guard finished else { return }
                        self.setPropertiesForEndedStateAtPosition(.Middle)
                    }
                )
            }
        default:
            break
        }
    }
    
    private func setPropertiesForChangedStateFromPosition(fromPosition: Position, toPosition: Position, byOffsetX offsetX: CGFloat) {
        let width = self.view.bounds.size.width
        let multiplier = offsetX / width
        let alphaDuration = self.scaleAlphaFactor * multiplier
        
        func setPropertiesForChangedStateFromLeftToMiddle() {
            self.setConstantOfCenterXConstraintForLeftView(-offsetX, middleView: width - offsetX, rightView: 2 * width - offsetX)
            self.setAlphaForLeftView(self.endAlpha - alphaDuration, middleView: self.startAlpha + alphaDuration, rightView: self.startAlpha)
            self.topVisualEffectView.alpha = 1.0 - multiplier
        }
        
        func setPropertiesForChangedStateFromMiddleToLeft() {
            self.setConstantOfCenterXConstraintForLeftView(-width + offsetX, middleView: offsetX, rightView: width + offsetX)
            self.setAlphaForLeftView(self.startAlpha + alphaDuration, middleView: self.endAlpha - alphaDuration, rightView: self.startAlpha)
            self.topVisualEffectView.alpha = multiplier
        }
        
        func setPropertiesForChangedStateFromMiddleToRight() {
            self.setConstantOfCenterXConstraintForLeftView(-width - offsetX, middleView: -offsetX, rightView: width - offsetX)
            self.setAlphaForLeftView(self.startAlpha, middleView: self.endAlpha - alphaDuration, rightView: self.startAlpha + alphaDuration)
            self.topVisualEffectView.alpha = multiplier
        }
        
        func setPropertiesForChangedStateFromRightToMiddle() {
            self.setConstantOfCenterXConstraintForLeftView(-2 * width + offsetX, middleView: -width + offsetX, rightView: offsetX)
            self.setAlphaForLeftView(self.startAlpha, middleView: self.startAlpha + alphaDuration, rightView: self.endAlpha - alphaDuration)
            self.topVisualEffectView.alpha = 1.0 - multiplier
        }
        
        switch fromPosition {
        case .Left      where toPosition == .Middle:    setPropertiesForChangedStateFromLeftToMiddle()
        case .Middle    where toPosition == .Left:      setPropertiesForChangedStateFromMiddleToLeft()
        case .Middle    where toPosition == .Right:     setPropertiesForChangedStateFromMiddleToRight()
        case .Right     where toPosition == .Middle:    setPropertiesForChangedStateFromRightToMiddle()
        default: break
        }
    }
    
    private func setPropertiesForEndedStateAtPosition(position: Position) {
        switch position {
        case .Left:     self.pageControl.currentPage = 0
        case .Middle:   self.pageControl.currentPage = 1
        case .Right:    self.pageControl.currentPage = 2
        }
    }
    
    private func setConstantOfCenterXConstraintForLeftView(leftConstant: CGFloat, middleView middleConstant: CGFloat, rightView rightConstant: CGFloat) {
        self.leftViewCenterXConstraint.constant     = leftConstant
        self.middleViewCenterXConstraint.constant   = middleConstant
        self.rightViewCenterXConstraint.constant    = rightConstant
    }
    
    private func setAlphaForLeftView(leftAlpha: CGFloat, middleView middleAlpha: CGFloat, rightView rightAlpha: CGFloat) {
        self.leftView.alpha     = leftAlpha
        self.middleView.alpha   = middleAlpha
        self.rightView.alpha    = rightAlpha
    }
    
}

// MARK: Gesture Recognizer

extension PlayerViewController {
    
    func didRecognizeByGestureForSlider(panGestureRecognizer: UIPanGestureRecognizer) {
        
        func updateProgressBarWithConstant(constant: CGFloat) {
            let multiplier = constant / self.progressBar.frame.size.width
            self.view.removeConstraint(playedProgressBarWidthConstrant)
            playedProgressBarWidthConstrant = NSLayoutConstraint(
                item: playedProgressBar,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: progressBar,
                attribute: .Width,
                multiplier: multiplier,
                constant: 0
            )
            self.view.addConstraint(playedProgressBarWidthConstrant)
            
            self.sliderViewLeadingSpaceConstraint.constant = constant
        }
        
        func changeLeadingSpaceConstraint() {
            let newPosition = self.sliderViewLeadingSpaceConstraint.constant + panGestureRecognizer.translationInView(self.sliderView).x
            panGestureRecognizer.setTranslation(CGPointZero, inView: self.sliderView)
            
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
            let image = UIImage.imageWithColor(UIColor.blackColor(), withSize: self.sliderView.frame.size)
            self.tooltip.backgroundImageView.image = image.imageWithRadius(self.sliderView.frame.size.height / 2)
            
            marginTooltipConstraint = NSLayoutConstraint(
                item: self.sliderView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self.tooltip,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0
            )
            
            verticalTooltipConstraint = NSLayoutConstraint(
                item: self.sliderView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.tooltip,
                attribute: .Bottom,
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
        case .Began:
            changeLeadingSpaceConstraint()
            oldSliderViewConstant = self.sliderViewLeadingSpaceConstraint.constant
            
            let currentTimeFormatter = Date.getStringFormatFromTime(currentTime)
            currentTimeLabel.text = currentTimeFormatter
            tooltip.title = currentTimeFormatter
            
            self.view.addSubview(tooltip)
            getTooltip()
        case .Changed:
            changeLeadingSpaceConstraint()
            
            let currentTimeFormatter = getTimeFormaterFromSliderViewConstraint()
            currentTimeLabel.text = currentTimeFormatter
            tooltip.title = currentTimeFormatter
        case .Ended:
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
        case .Cancelled:
            changeLeadingSpaceConstraint()
            currentTimeLabel.text = getTimeFormaterFromSliderViewConstraint()
            
            removeTooltip()
            tooltip.removeFromSuperview()
        default:
            break
        }
    }
    
}
