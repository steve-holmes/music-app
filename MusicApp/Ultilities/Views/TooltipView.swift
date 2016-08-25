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
        self.layer.cornerRadius = self.bounds.size.height / 4
        
        titleLabel = UILabel(frame: bounds)
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(titleLabel)
    }
    
    var originX: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
            titleLabel.frame = bounds
        }
    }
    
    var originY: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
            titleLabel.frame = bounds
        }
    }
    
    var sizeWidth: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
            titleLabel.frame = bounds
        }
    }
    
    var sizeHeight: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
            titleLabel.frame = bounds
        }
    }
    
    var title: String {
        didSet {
            titleLabel?.text = title
        }
    }
    
    var titleLabel: UILabel!
    
}
