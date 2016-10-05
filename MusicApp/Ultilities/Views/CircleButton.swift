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
    
    var circleColor: UIColor = UIColor.white { didSet { update() } }
    var iconColor: UIColor = UIColor.white { didSet { update() } }
    var circleWidth: CGFloat = 1 { didSet { update() } }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.adjustsImageWhenHighlighted = false
        update()
    }
    
    // MARK: Update UI
    
    fileprivate func update() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.borderColor = circleColor.cgColor
        self.layer.borderWidth = circleWidth
        
        let defaultImage = self.image(for: .normal)?.image(withColor: iconColor)
        
        var highlightedImage = UIImage
            .image(withColor: iconColor, withSize: self.bounds.size)
            .image(withRadius: self.bounds.size.width)
        
        if let innerImage = defaultImage {
            highlightedImage = highlightedImage.image(
                withoutInnerImage: innerImage,
                atCenter: CGPoint(
                    x: highlightedImage.size.width / 2,
                    y: highlightedImage.size.height / 2
                )
            )
        }
        
        self.setImage(defaultImage, for: .normal)
        self.setImage(highlightedImage, for: .highlighted)
    }

}

class SolidCircleButton: CircleButton {
    
    fileprivate override func update() {
        
    }
    
}

class AnimatedCircleButton: CircleButton {
    
    fileprivate override func update() {
        super.update()
    }
    
}
