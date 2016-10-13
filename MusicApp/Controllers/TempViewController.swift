//
//  TempViewController.swift
//  MusicApp
//
//  Created by HungDo on 10/13/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    @IBOutlet weak var bottomView: CircleButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.image = UIImage(named: "background")
        bottomView.borderWidth = 2
        bottomView.circleColor = UIColor.red
        bottomView.type = .border
        bottomView.type = .inner
        bottomView.type = .border
        
        let size = min(self.view.bounds.size.width, self.view.bounds.size.height)
        let sampleButton = CircleButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        self.view.addSubview(sampleButton)
        sampleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sampleButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        sampleButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        sampleButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.view.layoutIfNeeded()
        
        sampleButton.image = UIImage(named: "background")
        sampleButton.borderWidth = 2
        sampleButton.circleColor = UIColor.red
        sampleButton.type = .border
        
        bottomView.addTarget(self, action: #selector(handleEvent), forEvent: .touchUpInside)
        sampleButton.addTarget(self, action: #selector(handleEvent), forEvent: .touchUpInside)
    }
    
    func handleEvent() {
        print(#function)
    }

}
