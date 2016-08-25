//
//  TooltipView.swift
//  MusicApp
//
//  Created by HungDo on 8/25/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class TooltipView: UIView {
    
    static let sharedTooltipView = TooltipView(frame: CGRectZero)

    init(title: String = "", frame: CGRect) {
        self.title = title
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clearColor()
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        backgroundImageView = UIImageView()
        
        self.addSubview(backgroundImageView)
        self.addSubview(titleLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalTitleLabelContraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(10)-[titleLabel]-(10)-|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel]
        )
        
        let verticalTitleLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[titleLabel]|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel]
        )
        
        let horizontalBackgroundImageViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[backgroundImage]|",
            options: [],
            metrics: nil,
            views: ["backgroundImage": backgroundImageView]
        )
        
        let verticalBackgroundImageViewConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[backgroundImage]|",
            options: [],
            metrics: nil,
            views: ["backgroundImage": backgroundImageView]
        )
        
        self.addConstraints(horizontalTitleLabelContraints)
        self.addConstraints(verticalTitleLabelConstraints)
        self.addConstraints(horizontalBackgroundImageViewConstraints)
        self.addConstraints(verticalBackgroundImageViewConstraints)
        
        self.layoutIfNeeded()
    }
    
    var title: String {
        didSet {
            titleLabel?.text = title
        }
    }
    
    var titleLabel: UILabel!
    
    var backgroundImageView: UIImageView!
    
}
