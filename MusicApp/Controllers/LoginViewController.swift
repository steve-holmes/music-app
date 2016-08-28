//
//  LoginViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/28/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogo()
    }
    
    private func setupLogo() {
        let image = logoImageView.image?.imageWithColor(UIColor.whiteColor())
        logoImageView.image = image
    }

}

extension LoginViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
