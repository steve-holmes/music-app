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
        self.backgroundColor = UIColor.blackColor()
        
        titleLabel = UILabel(frame: bounds)
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 11)
        
        self.addSubview(titleLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let horizontalContraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(5)-[titleLabel]-(5)-|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel]
        )
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[titleLabel]|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel]
        )
        
        self.addConstraints(horizontalContraints)
        self.addConstraints(verticalConstraints)
        
        self.layoutIfNeeded()
        
        self.layer.cornerRadius = self.bounds.size.height / 4
    }
    
    var title: String {
        didSet {
            titleLabel?.text = title
        }
    }
    
    var titleLabel: UILabel!
    
    private var targetRect: CGRect?
    private var containerView: UIView?
    
    func setTargetRect(targetRect: CGRect, inView targetView: UIView) {
        self.targetRect = targetRect
        self.containerView = targetView
    }
    
}
