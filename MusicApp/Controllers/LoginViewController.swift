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
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginBarButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerBarButtonCenterXConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    
    @IBAction func backButtonTapped() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginBarButtonTapped() {
        state = .login
    }
    
    @IBAction func registerBarButtonTapped() {
        state = .register
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
        
        self.view.backgroundColor = ColorConstants.background
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didRecognizeByTapGestureRecognizer(_:))))
        
        setupLogo()
        setupTextFields()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Initialization
    
    fileprivate func setupLogo() {
        let image = logoImageView.image?.image(withColor: UIColor.white)
        logoImageView.image = image
    }
    
    fileprivate func setupTextFields() {
        let emailImage = emailImageView.image?.image(withColor: UIColor.white)
        let passwordImage = passwordImageView.image?.image(withColor: UIColor.white)
        emailImageView.image = emailImage
        passwordImageView.image = passwordImage
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    fileprivate func setupConstraints() {
        let width = self.view.bounds.size.width
        self.loginBarButtonCenterXConstraint.constant = -width / 4
        self.registerBarButtonCenterXConstraint.constant = width / 4
    }
    
    // MARK: Gesture Recognizer
    
    func didRecognizeByTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: State
    
    fileprivate enum State {
        case login
        case register
    }
    
    fileprivate var state: State = .login {
        didSet {
            if state == oldValue { return }
            switch state {
            case .login:
                loginBarButton.setTitleColor(UIColor.white, for: UIControlState())
                loginBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
                
                registerBarButton.setTitleColor(ColorConstants.background, for: UIControlState())
                registerBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17)
                
                loginButton.setTitle("Login", for: UIControlState())
            case .register:
                loginBarButton.setTitleColor(ColorConstants.background, for: UIControlState())
                loginBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17)
                
                registerBarButton.setTitleColor(UIColor.white, for: UIControlState())
                registerBarButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
                
                loginButton.setTitle("Register", for: UIControlState())
            }
        }
    }

}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: Status bar

extension LoginViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
