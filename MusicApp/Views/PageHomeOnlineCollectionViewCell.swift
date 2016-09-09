//
//  PageHomeOnlineCollectionViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/7/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class PageHomeOnlineCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? { didSet { pageImageView.image = image } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(pageImageView)
        setupConstraints()
    }
    
    private var pageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func setupConstraints() {
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[imageView]|",
            options: [],
            metrics: nil,
            views: ["imageView": pageImageView]
        )
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[imageView]|",
            options: [],
            metrics: nil,
            views: ["imageView": pageImageView]
        )
        contentView.addConstraints(horizontalConstraints)
        contentView.addConstraints(verticalConstraints)
    }
    
}
