//
//  SharedView.swift
//  MusicApp
//
//  Created by HungDo on 9/20/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SharedView: UIView {

    // MARK: Buttons
    
    private lazy var buttonWidth: CGFloat = self.bounds.size.width / 5
    
    private lazy var facebookButton: SharedButton = SharedButton(width: self.buttonWidth)
    private lazy var smsButton: SharedButton = SharedButton(width: self.buttonWidth)
    private lazy var emailButton: SharedButton = SharedButton(width: self.buttonWidth)
    private lazy var copyLinkButton: SharedButton = SharedButton(width: self.buttonWidth)

    // MARK: Labels
    
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.avenirNextFont()
        label.textColor = ColorConstants.text
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(titleLabel)
        self.addSubview(bottomView)
        bottomView.addSubview(containerView)
        containerView.addSubview(facebookButton)
        containerView.addSubview(smsButton)
        containerView.addSubview(emailButton)
        containerView.addSubview(copyLinkButton)
        
        facebookButton.setTitle("Facebook", for: .normal)
        smsButton.setTitle("SMS", for: .normal)
        emailButton.setTitle("Email", for: .normal)
        copyLinkButton.setTitle("Copy Link", for: .normal)
        titleLabel.text = "Hello World"
        
        self.backgroundColor = UIColor.white
        
        facebookButton.backgroundColor = UIColor.blue
        smsButton.backgroundColor = UIColor.green
        emailButton.backgroundColor = UIColor.red
        copyLinkButton.backgroundColor = UIColor.green
    
        setupConstraints()
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        setupConstraintsForTitleLabel()
        setupConstraintsForButtons()
        setupConstraintsForIndicator()
        layoutIfNeeded()
    }
    
    private func setupConstraintsForTitleLabel() {
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0/5.0).isActive = true
    }
    
    private func setupConstraintsForIndicator() {
        let indicatorView = UIView()
        indicatorView.backgroundColor = ColorConstants.toolbarNormalBackground
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        self.bringSubview(toFront: indicatorView)
        
        let paddingWidth: CGFloat = 10
        
        indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingWidth).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddingWidth).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        indicatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    private func setupConstraintsForButtons() {
        
        let paddingWidth: CGFloat = 20
        
        func setupConstraintsForContainerView() {
            bottomView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            
            containerView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        }
        
        func setupConstraintsForFacebookButton() {
            facebookButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            facebookButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            facebookButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            facebookButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0/5.0).isActive = true
            facebookButton.widthAnchor.constraint(equalTo: facebookButton.heightAnchor).isActive = true
        }
        
        func setupConstraintsForSMSButton() {
            smsButton.leadingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: paddingWidth).isActive = true
            smsButton.topAnchor.constraint(equalTo: facebookButton.topAnchor).isActive = true
            smsButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor).isActive = true
            smsButton.heightAnchor.constraint(equalTo: facebookButton.heightAnchor).isActive = true
        }
        
        func setupConstraintsForEmailButton() {
            emailButton.leadingAnchor.constraint(equalTo: smsButton.trailingAnchor, constant: paddingWidth).isActive = true
            emailButton.topAnchor.constraint(equalTo: facebookButton.topAnchor).isActive = true
            emailButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor).isActive = true
            emailButton.heightAnchor.constraint(equalTo: facebookButton.heightAnchor).isActive = true
        }
        
        func setupConstraintsForCopyLinkButton() {
            copyLinkButton.leadingAnchor.constraint(equalTo: emailButton.trailingAnchor, constant: paddingWidth).isActive = true
            copyLinkButton.topAnchor.constraint(equalTo: facebookButton.topAnchor).isActive = true
            copyLinkButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor).isActive = true
            copyLinkButton.heightAnchor.constraint(equalTo: facebookButton.heightAnchor).isActive = true
            copyLinkButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        }
        
        setupConstraintsForContainerView()
        setupConstraintsForFacebookButton()
        setupConstraintsForSMSButton()
        setupConstraintsForEmailButton()
        setupConstraintsForCopyLinkButton()
    }
    
    // MARK: Target-Action Methods
    
    func addTargetForFacebookButton(_ target: Any?, action: Selector, for events: UIControlEvents) {
        facebookButton.addTarget(target, action: action, for: events)
    }
    
    func addTargetForSMSButton(_ target: Any?, action: Selector, for events: UIControlEvents) {
        smsButton.addTarget(target, action: action, for: events)
    }
    
    func addTargetForEmailButton(_ target: Any?, action: Selector, for events: UIControlEvents) {
        emailButton.addTarget(target, action: action, for: events)
    }
    
    func addTargetForCopyLinkButton(_ target: Any?, action: Selector, for events: UIControlEvents) {
        copyLinkButton.addTarget(target, action: action, for: events)
    }

}

// MARK: Shared Button - Only for Shared View

fileprivate class SharedButton: CircleButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(width: CGFloat) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width)))
    }
    
    private func commonInit() {
        self.setTitleColor(ColorConstants.text, for: .normal)
        self.titleLabel?.font = UIFont.avenirNextFont()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
