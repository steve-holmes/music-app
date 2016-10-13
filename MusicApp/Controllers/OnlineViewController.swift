//
//  OnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit
import PageMenu

class OnlineViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet fileprivate weak var topView: UIView!
    @IBOutlet fileprivate weak var headerView: UIView!
    @IBOutlet fileprivate weak var searchView: UIView!
    @IBOutlet fileprivate weak var indicatorView: UIView!
    @IBOutlet fileprivate weak var contentView: UIView!

    @IBOutlet weak var topViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchViews()
        setupSearchController()
        setupPageMenu()
        
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Notifications
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveDidMoveByOffsetNotification(_:)),
            name: OnlineChildViewController.didMoveByOffsetNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveDidMoveByVelocityNotification(_:)),
            name: OnlineChildViewController.didMoveByVelocityNotification,
            object: nil
        )
    }
    
    func didReceiveDidMoveByOffsetNotification(_ notification: Notification) {
        guard let offset = notification.userInfo?["offset"] as? CGFloat,
            let controller = notification.object as? OnlineChildViewController else { return }
        self.onlineChildViewController(controller, didMoveByOffset: offset)
    }
    
    func didReceiveDidMoveByVelocityNotification(_ notification: Notification) {
        guard let velocity = notification.userInfo?["velocity"] as? CGFloat,
            let controller = notification.object as? OnlineChildViewController else { return }
        self.onlineChildViewController(controller, didMoveByVelocity: velocity)
    }
    
    // MARK: Search Controller
    
    private func setupSearchViews() {
        topView.backgroundColor = ColorConstants.background
        headerView.backgroundColor = ColorConstants.background
        headerView.clipsToBounds = true
        searchView.backgroundColor = ColorConstants.background
        indicatorView.backgroundColor = ColorConstants.main
    }
    
    fileprivate var searchController: UISearchController!
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barTintColor = ColorConstants.background
        
        let searchTextField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchTextField.font = UIFont.avenirNextFont().withSize(15)
        let searchBarButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBarButton.setTitleTextAttributes([
            NSFontAttributeName: UIFont.avenirNextFont().withSize(15),
            NSForegroundColorAttributeName: ColorConstants.text
        ], for: .normal)
        
        searchView.addSubview(searchController.searchBar)
    }
    
    
    // MARK: Page Menu
    
    fileprivate var pageMenu: CAPSPageMenu!
    
    private func setupPageMenu() {
        let childControllers: [OnlineChildViewController] = [
            (controller: ControllersIdentifiers.homeOnline,     title: "Home"),
            (controller: ControllersIdentifiers.playlistOnline, title: "Playlist"),
            (controller: ControllersIdentifiers.songOnline,     title: "Song"),
            (controller: ControllersIdentifiers.videoOnline,    title: "Video"),
            (controller: ControllersIdentifiers.rankOnline,     title: "Rank"),
            (controller: ControllersIdentifiers.singerOnline,   title: "Singer")
        ].flatMap { controllerTuple in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: controllerTuple.controller) as? OnlineChildViewController
            controller?.title = controllerTuple.title
            return controller
        }
        
        let bottomColor = UIColor(white: 200/255, alpha: 1)
        let menuColor = UIColor(white: 250/255, alpha: 1)
        
        let colorOptions: [CAPSPageMenuOption] = [
            .viewBackgroundColor(ColorConstants.background),
            .scrollMenuBackgroundColor(menuColor),
            .selectionIndicatorColor(ColorConstants.main),
            .selectedMenuItemLabelColor(ColorConstants.main),
            .unselectedMenuItemLabelColor(ColorConstants.text),
            .bottomMenuHairlineColor(bottomColor)
        ]
        
        let dimensionOptions: [CAPSPageMenuOption] = [
            .menuHeight(35),
            .menuMargin(0),
            .selectionIndicatorHeight(1.5)
        ]
        
        let otherOptions: [CAPSPageMenuOption] = [
            .menuItemFont(UIFont.avenirNextFont().withSize(15)),
            .scrollAnimationDurationOnMenuItemTap(300)
        ]
        
        self.pageMenu = CAPSPageMenu(
            viewControllers: childControllers,
            frame: self.contentView.bounds,
            pageMenuOptions: colorOptions + dimensionOptions + otherOptions
        )
        self.contentView.addSubview(self.pageMenu.view)
    }
    
    // MARK: Search Bar
    
    private var searchState: BarState = .visible
    private let durationForSearchBar: TimeInterval = 0.5
    private lazy var searchSize: CGFloat = self.searchView.bounds.size.height
    
    fileprivate func searchBarDidMoveToTop(distance: CGFloat) {
        if searchController.isActive { return }
        
        switch searchState {
        case .visible:
            searchState = .changed
            fallthrough
        case .changed:
            if distance < searchSize {
                self.searchBarSetPropertiesForChangedState(distance: distance, toState: .hidden)
            } else {
                self.searchBarSetPropertiesForEndState(state: .hidden)
            }
        case .hidden: break
        default: break
        }
    }
    
    fileprivate func searchBarDidMoveToBottom(distance: CGFloat) {
        switch searchState {
        case .hidden:
            searchState = .changed
            fallthrough
        case .changed:
            if distance < searchSize {
                self.searchBarSetPropertiesForChangedState(distance: distance, toState: .visible)
            } else {
                self.searchBarSetPropertiesForEndState(state: .visible)
            }
        case .visible: break
        default: break
        }
    }
    
    fileprivate func searchBarMoveUp(velocity: CGFloat, animated: Bool) {
        if searchController.isActive { return }
        
        if !animated {
            return
        }
        
        switch searchState {
        case .visible:
            UIView.animate(withDuration: durationForSearchBar) {
                self.searchBarDidHidden()
            }
            searchState = .hidden
        case .hidden: break
        default: break
        }
    }
    
    fileprivate func searchBarMoveDown(velocity: CGFloat, animated: Bool) {
        if !animated {
            return
        }
        
        switch searchState {
        case .hidden:
            UIView.animate(withDuration: durationForSearchBar) {
                self.searchBarDidVisible()
            }
            searchState = .visible
        case .visible: break
        default: break
        }
    }
    
    private func searchBarSetPropertiesForChangedState(distance: CGFloat, toState state: BarState) {
    
        func setPropertiesToVisible() {
            searchViewTopConstraint.constant = distance - searchSize
            topViewBottomConstraint.constant = -searchViewTopConstraint.constant
        }
        
        func setPropertiesToHidden() {
            searchViewTopConstraint.constant = -distance
            topViewBottomConstraint.constant = distance
        }
        
        switch state {
        case .visible: setPropertiesToVisible()
        case .hidden:  setPropertiesToHidden()
        default: break
        }
    }
    
    private func searchBarSetPropertiesForEndState(state: BarState) {
        switch state {
        case .visible:  self.searchState = .visible; self.searchBarDidVisible()
        case .hidden:   self.searchState = .hidden; self.searchBarDidHidden()
        default: break
        }
    }
    
    private func searchBarDidHidden() {
        searchViewTopConstraint.constant = -searchSize
        topViewBottomConstraint.constant = searchSize
        view.layoutIfNeeded()
    }
    
    private func searchBarDidVisible() {
        searchViewTopConstraint.constant = 0
        topViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

}

// MARK: UISearchResultsUpdating

extension OnlineViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
    }
    
}

// MARK: OnlineChildViewController

class OnlineChildViewController: UIViewController, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        func sign(_ number: CGFloat) -> CGFloat { return number < 0 ? -1.0 : 1.0 }
        
        let offsetY = scrollView.panGestureRecognizer.translation(in: self.view).y
        let velocityY = scrollView.panGestureRecognizer.velocity(in: self.view).y
        
        if abs(velocityY) > self.maximumVelocityY {
            NotificationCenter.default.post(
                name: OnlineChildViewController.didMoveByVelocityNotification,
                object: self,
                userInfo: ["velocity": velocityY]
            )
        } else if abs(offsetY) > self.maximumTranslationY {
            let offset = (abs(offsetY) - self.maximumTranslationY) * sign(offsetY)
            NotificationCenter.default.post(
                name: OnlineChildViewController.didMoveByOffsetNotification,
                object: self,
                userInfo: ["offset": offset]
            )
        }
    }
    
    // MARK: OnlineChildViewController - Velocity and Translation
    
    private var maximumVelocityY: CGFloat = 2000
    private var maximumTranslationY: CGFloat = 200
    
    // MARK: OnlineChildViewController - Notification Names
    
    static let didMoveByVelocityNotification = NSNotification.Name("OnlineChildViewControllerDidMoveByVelocityNotification")
    static let didMoveByOffsetNotification = NSNotification.Name("OnlineChildViewControllerDidMoveByOffsetNotification")
    
}

// MARK: OnlineChildViewControllerDelegate

protocol OnlineChildViewControllerDelegate {

    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveByOffset offset: CGFloat)
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveByVelocity velocity: CGFloat)
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveUpByOffset offset: CGFloat)
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveDownByOffset offset: CGFloat)
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveUpByVelocity velocity: CGFloat)
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveDownByVelocity velocity: CGFloat)
    
}

extension OnlineChildViewControllerDelegate {
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveByOffset offset: CGFloat) {
        if offset < 0   { self.onlineChildViewController(controller, didMoveUpByOffset: -offset) }
        else            { self.onlineChildViewController(controller, didMoveDownByOffset: offset) }
    }
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveByVelocity velocity: CGFloat) {
        if velocity < 0 { self.onlineChildViewController(controller, didMoveUpByVelocity: -velocity) }
        else            { self.onlineChildViewController(controller, didMoveDownByVelocity: velocity) }
    }
    
}

extension OnlineViewController: OnlineChildViewControllerDelegate {
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveUpByOffset offset: CGFloat) {
        self.searchBarDidMoveToTop(distance: offset)
    }
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveDownByOffset offset: CGFloat) {
        self.searchBarDidMoveToBottom(distance: offset)
    }
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveUpByVelocity velocity: CGFloat) {
        self.searchBarMoveUp(velocity: velocity, animated: true)
    }
    
    func onlineChildViewController(_ controller: OnlineChildViewController, didMoveDownByVelocity velocity: CGFloat) {
        self.searchBarMoveDown(velocity: velocity, animated: true)
    }
    
}
