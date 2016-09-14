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
    
    fileprivate func commonInit() {
        contentView.addSubview(pageImageView)
        setupConstraints()
    }
    
    fileprivate var pageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate func setupConstraints() {
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[imageView]|",
            options: [],
            metrics: nil,
            views: ["imageView": pageImageView]
        )
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[imageView]|",
            options: [],
            metrics: nil,
            views: ["imageView": pageImageView]
        )
        contentView.addConstraints(horizontalConstraints)
        contentView.addConstraints(verticalConstraints)
    }
    
}
