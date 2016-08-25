//
//  CircleButton.swift
//  MusicApp
//
//  Created by HungDo on 8/21/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    // MARK: Public propreties
    
    var circleColor: UIColor = UIColor.whiteColor() { didSet { updateButton() } }
    var iconColor: UIColor = UIColor.whiteColor() { didSet { updateButton() } }
    var circleWidth: CGFloat = 1 { didSet { updateButton() } }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.adjustsImageWhenHighlighted = false
        self.layer.cornerRadius = self.bounds.size.width / 2
        
        updateButton()
    }
    
    // MARK: Update UI
    
    private func updateButton() {
        self.layer.borderColor = circleColor.CGColor
        self.layer.borderWidth = circleWidth
        
        let defaultImage = self.imageForState(.Normal)?.imageWithColor(iconColor)
        
        var highlightedImage = UIImage
            .imageWithColor(iconColor, withSize: self.bounds.size)
            .imageWithRadius(self.bounds.size.width)
        
        if let innerImage = defaultImage {
            highlightedImage = highlightedImage.imageWithoutInnerImage(
                innerImage,
                atCenter: CGPoint(
                    x: highlightedImage.size.width / 2,
                    y: highlightedImage.size.height / 2
                )
            )
        }
        
        self.setImage(defaultImage, forState: .Normal)
        self.setImage(highlightedImage, forState: .Highlighted)
    }

}

class SolidCircleButton: CircleButton {
    
    private override func updateButton() {
        
    }
    
}

class AnimatedCircleButton: CircleButton {
    
    private override func updateButton() {
        super.updateButton()
    }
    
}
