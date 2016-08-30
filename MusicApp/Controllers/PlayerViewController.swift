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
    
    func playerViewController(controller: PlayerViewController, fromChildViewController childController: SinglePlayerViewController, didRecognizeByGesture gestureRecognizer: UIPanGestureRecognizer)
    func dismissPlayerViewController(controller: PlayerViewController, completion: (() -> Void)?)
    
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
    
    // MARK: Outlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    @IBOutlet weak var sliderViewLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var playedProgressBarWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var unloadProgressBarWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backwardButtonLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var forwardButtonTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func dismissButtonTapped() {
        self.delegate?.dismissPlayerViewController(self, completion: nil)
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
    
    var panGestureRecognizer: UIPanGestureRecognizer {
        return singlePlayerViewController.panGestureRecognizer
    }
    
    private var previousOffsetX: CGFloat = 0
    
    private var startAlpha: CGFloat = 0.2
    private var endAlpha: CGFloat = 1.0
    private lazy var scaleAlphaFactor: CGFloat = self.endAlpha - self.startAlpha
    
    private var transitionDuration: NSTimeInterval = 0.5
    
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
        
        self.leftView.alpha = self.endAlpha
        self.middleView.alpha = self.startAlpha
        self.rightView.alpha = self.startAlpha
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
        return controller
    }()
    
    private lazy var singlePlayerViewController: SinglePlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.SinglePlayerController) as! SinglePlayerViewController
        controller.delegate = self
        return controller
    }()
    
    
    private lazy var lyricPlayerViewController: LyricPlayerViewController = {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ControllersIdentifiers.LyricPlayerController) as! LyricPlayerViewController
        return controller
    }()
    
    
    // MARK: Detail Player View Position
    
    enum Position {
        case Left
        case Middle
        case Right
    }
    
    private var position: Position = .Left {
        didSet {
            func setAlphaPropertyForLeftView(leftAlpha: CGFloat, forMiddleView middleAlpha: CGFloat, forRightView rightAlpha: CGFloat) {
                self.leftView.alpha = leftAlpha
                self.middleView.alpha = middleAlpha
                self.rightView.alpha = rightAlpha
            }
            
            switch position {
            case .Left:
                setAlphaPropertyForLeftView(self.endAlpha, forMiddleView: self.startAlpha, forRightView: self.startAlpha)
                self.topVisualEffectView.alpha = 1
            case .Middle:
                setAlphaPropertyForLeftView(self.startAlpha, forMiddleView: self.endAlpha, forRightView: self.startAlpha)
                self.topVisualEffectView.alpha = 0
            case .Right:
                setAlphaPropertyForLeftView(self.startAlpha, forMiddleView: self.startAlpha, forRightView: self.endAlpha)
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

// MARK: UIScrollViewDelegate

extension PlayerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        
        let offsetX = scrollView.contentOffset.x - previousOffsetX
        var multiplier = offsetX / self.view.bounds.size.width
        let sign: CGFloat = multiplier < 0 ? -1 : 1
        multiplier = abs(multiplier)
        let alphaDuration = self.scaleAlphaFactor * multiplier
        
        func scrollViewDidScrollFromLeftViewToMiddleView() {
            self.leftView.alpha = self.endAlpha - alphaDuration
            self.middleView.alpha = self.startAlpha + alphaDuration
            self.topVisualEffectView.alpha = 1.0 - multiplier
        }
        
        func scrollViewDidScrollFromMiddleViewToLeftView() {
            self.leftView.alpha = self.startAlpha + alphaDuration
            self.middleView.alpha = self.endAlpha - alphaDuration
            self.topVisualEffectView.alpha = multiplier
        }
        
        func scrollViewDidScrollFromMiddleViewToRightView() {
            self.middleView.alpha = self.endAlpha - alphaDuration
            self.rightView.alpha = self.startAlpha + alphaDuration
            self.topVisualEffectView.alpha = multiplier
        }
        
        func scrollViewDidScrollFromRightViewToMiddleView() {
            self.middleView.alpha = self.startAlpha + alphaDuration
            self.rightView.alpha = self.endAlpha - alphaDuration
            self.topVisualEffectView.alpha = 1.0 - multiplier
        }
        
        switch position {
        case .Left: scrollViewDidScrollFromLeftViewToMiddleView()
        case .Middle where sign < 0: scrollViewDidScrollFromMiddleViewToLeftView()
        case .Middle where sign > 0: scrollViewDidScrollFromMiddleViewToRightView()
        case .Right: scrollViewDidScrollFromRightViewToMiddleView()
        default: break
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        self.previousOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === self.scrollView else { return }
        self.panGestureRecognizer.enabled = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        
        let offsetX = scrollView.contentOffset.x
        self.previousOffsetX = offsetX
        self.pageControl.currentPage = Int(offsetX / self.view.bounds.size.width)
        
        switch self.pageControl.currentPage {
        case 0: position = .Left
        case 1: position = .Middle
        case 2: position = .Right
        default: break
        }
    }
    
}

// MARK: SinglePlayerViewControllerDelegate

extension PlayerViewController: SinglePlayerViewControllerDelegate {
    
    func singlePlayerViewController(controller: SinglePlayerViewController, didRecognizeByTapGesture gestureRecognizer: UIPanGestureRecognizer) {
        self.delegate?.playerViewController(self, fromChildViewController: controller, didRecognizeByGesture: gestureRecognizer)
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

// MARK: - Status bar

extension PlayerViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
