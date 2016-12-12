//
//  ListPlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/21/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class ListPlayerViewController: UIViewController, PlayerChildViewController {

    // MARK: - Models
    
    var songs: [String] = [
        "aaaa",
        "bbbb"
    ]
    
    // MARK: - Outlets
    
    @IBOutlet weak var songTableView: UITableView!
    
    // MARK: Delegation
    
    weak var delegate: PlayerChildViewControllerDelegate?
    
    // MARK: Gesture Recognizer
    
    func performPanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.delegate?.playerChildViewController(self, options: .left, didRecognizeByPanGestureRecognizer: gestureRecognizer)
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.rowHeight = UITableViewAutomaticDimension
        songTableView.estimatedRowHeight = 20
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(performPanGestureRecognizer(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: Audio Player
    
    func play() {
    }
    
    func pause() {
    }
    
    func moveForward() {
    }
    
    func moveBackward() {
    }

}

// MARK: UITableViewDataSource

extension ListPlayerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.listPlayerTable, for: indexPath)
        
        if let listCell = cell as? ListPlayerTableViewCell {
            listCell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
}
