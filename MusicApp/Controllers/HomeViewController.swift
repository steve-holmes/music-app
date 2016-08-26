//
//  HomeViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/26/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mineButtonImageView: UIImageView!
    @IBOutlet weak var mineButtonLabel: UILabel!
    @IBOutlet weak var mineButtonBackgroundView: UIView!
    
    @IBOutlet weak var onlineButtonImageView: UIImageView!
    @IBOutlet weak var onlineButtonLabel: UILabel!
    @IBOutlet weak var onlineButtonBackgroundView: UIView!
    
    // MARK: Actions
    
    @IBAction func mineButtonTapped() {
        if state == .Online {
            state = .Mine
        }
    }
    
    @IBAction func onlineButtonTapped() {
        if state == .Mine {
            state = .Online
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        state = .Online
    }
    
    enum State {
        case Mine
        case Online
    }
    
    var state: State = .Online {
        didSet {
            switch state {
            case .Mine:
                let mineImage = mineButtonImageView.image?.imageWithColor(UIColor.whiteColor())
                let onlineImage = onlineButtonImageView.image?.imageWithColor(UIColor.blackColor())
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = UIColor.whiteColor()
                onlineButtonLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
                
                mineButtonBackgroundView.backgroundColor = UIColor.blueColor()
                onlineButtonBackgroundView.backgroundColor = UIColor.whiteColor()
            case .Online:
                let mineImage = mineButtonImageView.image?.imageWithColor(UIColor.blackColor())
                let onlineImage = onlineButtonImageView.image?.imageWithColor(UIColor.whiteColor())
                mineButtonImageView.image = mineImage
                onlineButtonImageView.image = onlineImage
                
                mineButtonLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
                onlineButtonLabel.textColor = UIColor.whiteColor()
                
                mineButtonBackgroundView.backgroundColor = UIColor.whiteColor()
                onlineButtonBackgroundView.backgroundColor = UIColor.blueColor()
            }
        }
    }

}
