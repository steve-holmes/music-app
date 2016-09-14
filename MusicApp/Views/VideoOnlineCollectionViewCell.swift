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
    var duration: TimeInterval? { didSet { durationLabel.text = "\(duration ?? 0)" } }
    
    @IBOutlet fileprivate weak var videoImageView: UIImageView!
    @IBOutlet fileprivate weak var videoNameLabel: UILabel!
    @IBOutlet fileprivate weak var singerNameLabel: UILabel!
    @IBOutlet fileprivate weak var numberOfListeningLabel: UILabel!
    @IBOutlet fileprivate weak var durationLabel: UILabel!
    
    @IBOutlet weak var numberOfListeningView: UIView!
    @IBOutlet weak var durationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradientLayerForView(numberOfListeningView)
        addGradientLayerForView(durationView)
    }
    
    fileprivate func addGradientLayerForView(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
    }
    
}
