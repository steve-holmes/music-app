//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/19/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol PlayerChildViewControllerDelegate {
    
    func playerChildViewController(
        controller: PlayerChildViewController,
        didRecognizeBySwipeGestureRecognizer swipeGestureRecognizer: UISwipeGestureRecognizer
    )
    
    func playerChildViewController(
        controller: PlayerChildViewController,
        options: PlayerChildViewControllerPanGestureRecognizerDirection?,
        didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer
    )
    
}

protocol PlayerChildViewController {
    
    var delegate: PlayerChildViewControllerDelegate? { get }
    
}

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
            self.view.addConstraint(playedProgressBarWidthConstrant)
            
            sliderViewLeadingSpaceConstraint?.constant = (progressBar.frame.size.width - sliderView.frame.size.width) * multiplier
        }
    }
    
    var backgroundImage: UIImage = UIImage(named: "background")!
    
    // MARK: Public APIs
    
    var position: Position {
        get {
            return self.detailPosition
        }
        set {
            self.detailPosition = newValue
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet private weak var leftView: UIView!
    @IBOutlet private weak var middleView: UIView!
    @IBOutlet private weak var rightView: UIView!
    
    @IBOutlet weak var playButton: CircleButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var unloadProgressBar: UIView!
    @IBOutlet weak var playedProgressBar: UIView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet private weak var leftViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var middleViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderViewLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var playedProgressBarWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var unloadProgressBarTrailingWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backwardButtonLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var forwardButtonTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func playPauseButtonTapped(button: UIButton) {
        print(#function)
    }
    
    @IBAction func backwardButtonTapped() {
        print(#function)
    }
    
    @IBAction func forwardButtonTapped() {
        print(#function)
    }
    
    // MARK: Private properties
    
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
        
        let width = self.view.bounds.size.width
        self.middleViewCenterXConstraint.constant = width
        self.rightViewCenterXConstraint.constant = 2 * width
        
        self.leftView.alpha = 1
        self.middleView.alpha = 0.5
        self.rightView.alpha = 0.5
        
        self.topVisualEffectView.alpha = 1
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
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.ListPlayerViewController) as! ListPlayerViewController
        controller.delegate = self
        return controller
    }()
    
    private lazy var singlePlayerViewController: SinglePlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.SinglePlayerViewController) as! SinglePlayerViewController
        controller.delegate = self
        return controller
    }()
    
    
    private lazy var lyricPlayerViewController: LyricPlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.LyricPlayerViewController) as! LyricPlayerViewController
        controller.delegate = self
        return controller
    }()
    
    
    // MARK: Detail Player View Position
    
    enum Position {
        case Left
        case Middle
        case Right
    }
    
    private var detailPosition: Position = .Left {
        didSet(oldPosition) {
            self.changeChildPlayerViewFromPosition(oldPosition, toPosition: detailPosition)
        }
    }
    
    // MARK: Change Detail Player Subviews
    
    private var translatedDuration: NSTimeInterval = 0.35
    
    private func changeChildPlayerViewFromPosition(fromPosition: Position, toPosition: Position) {
        if (fromPosition == .Left && toPosition == .Right) || (fromPosition == .Right && toPosition == .Left) {
            return
        }
        
        let width = self.view.bounds.size.width
        
        func setCenterXConstraintConstantForLeftView(leftConstant: CGFloat, forMiddleView middleConstant: CGFloat, forRightView rightConstant: CGFloat) {
            self.leftViewCenterXConstraint.constant = leftConstant
            self.middleViewCenterXConstraint.constant = middleConstant
            self.rightViewCenterXConstraint.constant = rightConstant
        }
        
        func setAlphaPropertyForLeftView(leftAlpha: CGFloat, forMiddleView middleAlpha: CGFloat, forRightView rightAlpha: CGFloat) {
            self.leftView.alpha = leftAlpha
            self.middleView.alpha = middleAlpha
            self.rightView.alpha = rightAlpha
        }
        
        func changeToMiddle() {
            setCenterXConstraintConstantForLeftView(-width, forMiddleView: 0, forRightView: width)
            setAlphaPropertyForLeftView(0.5, forMiddleView: 1.0, forRightView: 0.5)
            self.topVisualEffectView.alpha = 0
        }
        
        func changeToLeft() {
            setCenterXConstraintConstantForLeftView(0, forMiddleView: width, forRightView: 2 * width)
            setAlphaPropertyForLeftView(1.0, forMiddleView: 0.5, forRightView: 0.5)
            self.topVisualEffectView.alpha = 1
        }
        
        func changeToRight() {
            setCenterXConstraintConstantForLeftView(-2 * width, forMiddleView: -width, forRightView: 0)
            setAlphaPropertyForLeftView(0.5, forMiddleView: 0.5, forRightView: 1.0)
            self.topVisualEffectView.alpha = 1
        }
        
        UIView.animateWithDuration(
            translatedDuration, delay: 0, options: .CurveEaseIn,
            animations: {
                switch toPosition {
                case .Left:     changeToLeft()
                case .Middle:   changeToMiddle()
                case .Right:    changeToRight()
                }
                
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                guard completed else { return }
                switch toPosition {
                case .Left:   self.pageControl.currentPage = 0
                case .Middle: self.pageControl.currentPage = 1
                case .Right:  self.pageControl.currentPage = 2
                }
            }
        )
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
    
    func playerChildViewController(controller: PlayerChildViewController, didRecognizeBySwipeGestureRecognizer swipeGestureRecognizer: UISwipeGestureRecognizer) {
        switch position {
        case .Left where controller is ListPlayerViewController:
            self.listPlayerViewController(controller as! ListPlayerViewController, didRecognizeBySwipeGestureRecognizer: swipeGestureRecognizer)
        case .Middle where controller is SinglePlayerViewController:
            self.singlePlayerViewController(controller as! SinglePlayerViewController, didRecognizeBySwipeGestureRecognizer: swipeGestureRecognizer)
        case .Right where controller is LyricPlayerViewController:
            self.lyricPlayerViewController(controller as! LyricPlayerViewController, didRecognizeBySwipeGestureRecognizer: swipeGestureRecognizer)
        default:
            break
        }
    }
    
    private func listPlayerViewController(listPlayerController: ListPlayerViewController, didRecognizeBySwipeGestureRecognizer swipeGestureRecognizer: UISwipeGestureRecognizer) {
        if swipeGestureRecognizer.direction == .Left {
            position = .Middle
        }
    }
    
    private func singlePlayerViewController(singlePlayerController: SinglePlayerViewController, didRecognizeBySwipeGestureRecognizer swipeGestureRecognizer: UISwipeGestureRecognizer) {
        if swipeGestureRecognizer.direction == .Left {
            position = .Right
        } else if swipeGestureRecognizer.direction == .Right {
            position = .Left
        }
    }
    
    private func lyricPlayerViewController(lyricController: LyricPlayerViewController, didRecognizeBySwipeGestureRecognizer swipeGestureRecognizer: UISwipeGestureRecognizer) {
        if swipeGestureRecognizer.direction == .Right {
            position = .Middle
        }
    }
    
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
    
    private func listPlayerViewController(listPlayerController: ListPlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        print(#function)
    }
    
    private func singlePlayerViewController(singlePlayerController: SinglePlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        print(#function)
    }
    
    private func lyricPlayerViewController(lyricPlayerController: LyricPlayerViewController, didRecognizeByPanGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        print(#function)
    }
    
}

// MARK: Gesture Recognizer

extension PlayerViewController {
    
    func didRecognizeByGestureForSlider(panGestureRecognizer: UIPanGestureRecognizer) {
        
        func changeLeadingSpaceConstraint() {
            let newPosition = self.sliderViewLeadingSpaceConstraint.constant + panGestureRecognizer.translationInView(self.sliderView).x
            panGestureRecognizer.setTranslation(CGPointZero, inView: self.sliderView)
            
            if newPosition < 0 || newPosition > self.progressBar.frame.size.width - self.sliderView.frame.size.width {
                return
            }
            
            self.sliderViewLeadingSpaceConstraint.constant = newPosition
        }
        
        func getTimeFormaterFromSliderViewConstraint() -> String {
            let currentTime = Int(CGFloat(duration) * sliderViewLeadingSpaceConstraint.constant / (progressBar.frame.size.width - sliderView.frame.size.width))
            return Date.getStringFormatFromTime(currentTime)
        }
        
        func getTooltip() {
            let image = UIImage.imageWithColor(UIColor.blackColor(), withSize: self.sliderView.frame.size)
            self.tooltip.backgroundImageView.image = image.imageWithRadius(self.sliderView.frame.size.height / 4)
            
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
                self.sliderViewLeadingSpaceConstraint.constant = oldSliderViewConstant
                removeTooltip()
                tooltip.removeFromSuperview()
                return
            }
            currentTime = Int(CGFloat(duration) * sliderViewLeadingSpaceConstraint.constant / (progressBar.frame.size.width - sliderView.frame.size.width))
            removeTooltip()
            tooltip.removeFromSuperview()
        case .Cancelled:
            changeLeadingSpaceConstraint()
            removeTooltip()
            tooltip.removeFromSuperview()
            self.sliderViewLeadingSpaceConstraint.constant = oldSliderViewConstant
        default:
            break
        }
    }
    
}

// MARK: - Status bar

extension PlayerViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

// MARK: Add or remove a child view controller

private extension UIViewController {
    
    func displayContentController(controller: UIViewController, inView view: UIView) {
        self.addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
    
    func hideContentController(controller: UIViewController) {
        controller.willMoveToParentViewController(nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
}