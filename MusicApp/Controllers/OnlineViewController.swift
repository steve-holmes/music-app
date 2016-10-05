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
    @IBOutlet fileprivate weak var contentView: UIView!

    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.backgroundColor = ColorConstants.background
        
//        setupSearchController()
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
    
    fileprivate var searchController: UISearchController!
    
    private func setupSearchController() {
        searchController = UISearchController()
        self.display(contentController: searchController, in: self.headerView)
        
        if let searchView = searchController.view {
            searchView.translatesAutoresizingMaskIntoConstraints = false
            
            self.headerView.addConstraints([
                searchView.topAnchor.constraint(equalTo: self.headerView.topAnchor),
                searchView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor),
                searchView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
                searchView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor)
            ])
        }
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
        
        self.pageMenu = CAPSPageMenu(viewControllers: childControllers, frame: self.contentView.bounds, pageMenuOptions: nil)
        self.contentView.addSubview(self.pageMenu.view)
    }
    
    // MARK: Search Bar
    
    private var searchState: BarState = .visible
    
    fileprivate func searchBarDidMoveToTop(distance: CGFloat) {
        switch searchState {
        case .hidden: break
        default: break
        }
    }
    
    fileprivate func searchBarDidMoveToBottom(distance: CGFloat) {
        switch searchState {
        case .visible: break
        default: break
        }
    }
    
    fileprivate func searchBarMoveUp(velocity: CGFloat, animated: Bool) {
        print(#function)
    }
    
    fileprivate func searchBarMoveDown(velocity: CGFloat, animated: Bool) {
        print(#function)
    }
    
    private func searchBarSetPropertiesForChangedState(distance: CGFloat) {
    
    }
    
    private func searchBarSetPropertiesForEndState(distance: CGFloat, toState state: BarState) {
        switch state {
        case .visible:  self.searchBarDidVisible()
        case .hidden:   self.searchBarDidHidden()
        default: break
        }
    }
    
    private func searchBarDidHidden() {
        
    }
    
    private func searchBarDidVisible() {
        
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
