//
//  SongOfflineViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/28/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SongOfflineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sharedView = SharedView(frame: view.bounds)
        view.addSubview(sharedView)
        sharedView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            sharedView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            sharedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sharedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sharedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.layoutIfNeeded()
    }

}
