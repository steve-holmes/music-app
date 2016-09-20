//
//  SharedView.swift
//  MusicApp
//
//  Created by HungDo on 9/20/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class SharedView: UIView {

    private var facebookButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var smsButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var emailButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var copyLinkButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        self.addSubview(containerView)
        containerView.addSubview(facebookButton)
        containerView.addSubview(smsButton)
        containerView.addSubview(emailButton)
        containerView.addSubview(copyLinkButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        setupConstraintsForTitleLabel()
        setupConstraintsForIndicator()
        setupConstraintsForButtons()
    }
    
    private func setupConstraintsForTitleLabel() {
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[titleLabel]|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel]
        )
        
        let topConstraint = NSLayoutConstraint(
            item: titleLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        
        let heightConstraint = NSLayoutConstraint(
            item: titleLabel,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: 1.0/5.0,
            constant: 0
        )
        
        self.addConstraints(horizontalConstraints)
        self.addConstraints([topConstraint, heightConstraint])
    }
    
    private func setupConstraintsForIndicator() {
        let indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[incicatorView]|",
            options: [],
            metrics: nil,
            views: ["indicatorView": indicatorView]
        )
        
        let heightConstraint = NSLayoutConstraint(
            item: indicatorView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 1
        )
        
        self.addConstraints(horizontalConstraints)
        self.addConstraint(heightConstraint)
        
        indicatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    private func setupConstraintsForButtons() {
        
        let paddingWidth: CGFloat = 10
        
        func setupConstraintsForContainerView() {
            let centerXConstraint = NSLayoutConstraint(
                item: containerView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            )
            
            let centerYConstraint = NSLayoutConstraint(
                item: containerView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0
            )
            
            self.addConstraints([centerXConstraint, centerYConstraint])
        }
        
        func setupConstraintsForFacebookButton() {
            let verticalContraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[facebookButton]|",
                options: [],
                metrics: nil,
                views: ["facebookButton": facebookButton]
            )
            
            let leadingConstraint = NSLayoutConstraint(
                item: facebookButton,
                attribute: .leading,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .leading,
                multiplier: 1,
                constant: 0
            )
            
            let widthConstraint = NSLayoutConstraint(
                item: facebookButton,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 1.0/5.0,
                constant: 0
            )
            
            let ratioConstraint = NSLayoutConstraint(
                item: facebookButton,
                attribute: .width,
                relatedBy: .equal,
                toItem: facebookButton,
                attribute: .height,
                multiplier: 1,
                constant: 0
            )
            
            containerView.addConstraints(verticalContraints)
            containerView.addConstraint(leadingConstraint)
            self.addConstraint(widthConstraint)
            facebookButton.addConstraint(ratioConstraint)
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
