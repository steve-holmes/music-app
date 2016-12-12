//
//  RankOnlineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class RankOnlineViewController: OnlineChildViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = ColorConstants.background
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension RankOnlineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.rankOnlineTable, for: indexPath)
        return cell
    }
    
}

extension RankOnlineViewController: UITableViewDelegate {
    
}
