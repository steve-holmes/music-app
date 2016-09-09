//
//  VideoHomeOnlineCollectionViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/7/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class VideoHomeOnlineCollectionViewCell: UICollectionViewCell {
    
    var videoImage: UIImage? { didSet { videoImageView.image = videoImage } }
    var videoName: String? { didSet { videoNameLabel.text = videoName } }
    var singerName: String? { didSet { singerNameLabel.text = singerName } }
    
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var singerNameLabel: UILabel!
    @IBOutlet private weak var numberOfListeningLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var numberOfListeningView: UIView!
    @IBOutlet private weak var durationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradientLayerForView(numberOfListeningView)
        addGradientLayerForView(durationView)
    }
    
    private func addGradientLayerForView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.blackColor().CGColor,
            UIColor.clearColor().CGColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
    }
    
}
