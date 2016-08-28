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
    @IBOutlet weak var loginBarButton: UIButton!
    @IBOutlet weak var registerBarButton: UIButton!
    
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var loginBarButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerBarButtonCenterXConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func loginBarButtonTapped() {
        state = .Login
    }
    
    @IBAction func registerBarButtonTapped() {
        state = .Register
    }
    
    @IBAction func loginButtonTapped() {
        
    }
    
    @IBAction func facebookLoginButtonTapped() {
        
    }
    
    @IBAction func googleLoginButtonTapped() {
        
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didRecognizeByTapGestureRecognizer(_:))))
        
        setupLogo()
        setupTextFields()
        setupConstraints()
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
    
    private func setupTextFields() {
        let emailImage = emailImageView.image?.imageWithColor(UIColor.whiteColor())
        let passwordImage = passwordImageView.image?.imageWithColor(UIColor.whiteColor())
        emailImageView.image = emailImage
        passwordImageView.image = passwordImage
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    private func setupConstraints() {
        let width = self.view.bounds.size.width
        self.loginBarButtonCenterXConstraint.constant = -width / 4
        self.registerBarButtonCenterXConstraint.constant = width / 4
    }
    
    // MARK: Gesture Recognizer
    
    func didRecognizeByTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: State
    
    private enum State {
        case Login
        case Register
    }
    
    private var state: State = .Login {
        didSet {
            if state == oldValue { return }
            switch state {
            case .Login:
                loginBarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                loginBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
                
                registerBarButton.setTitleColor(UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), forState: .Normal)
                registerBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17)
                
                loginLabel.text = "Login"
            case .Register:
                loginBarButton.setTitleColor(UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1), forState: .Normal)
                loginBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17)
                
                registerBarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                registerBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
                
                loginLabel.text = "Register"
            }
        }
    }

}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: Status bar

extension LoginViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
