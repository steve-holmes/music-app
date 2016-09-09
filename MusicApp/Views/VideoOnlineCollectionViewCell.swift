//
//  VideoOnlineCollectionViewCell.swift
//  MusicApp
//
//  Created by HungDo on 9/8/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class VideoOnlineCollectionViewCell: UICollectionViewCell {
    
    var videoImage: UIImage? { didSet { videoImageView.image = videoImage } }
    var videoName: String? { didSet { videoNameLabel.text = videoName } }
    var singerName: String? { didSet { singerNameLabel.text = singerName } }
    var numberOfListening: Int? { didSet { numberOfListeningLabel.text = "\(numberOfListening ?? 0)" } }
    var duration: NSTimeInterval? { didSet { durationLabel.text = "\(duration ?? 0)" } }
    
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var singerNameLabel: UILabel!
    @IBOutlet private weak var numberOfListeningLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet weak var numberOfListeningView: UIView!
    @IBOutlet weak var durationView: UIView!
    
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
