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
    
    // MARK: Actions
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Initialization
    
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
