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
    
    @IBOutlet fileprivate weak var videoImageView: UIImageView!
    @IBOutlet fileprivate weak var videoNameLabel: UILabel!
    @IBOutlet fileprivate weak var singerNameLabel: UILabel!
    @IBOutlet fileprivate weak var numberOfListeningLabel: UILabel!
    @IBOutlet fileprivate weak var durationLabel: UILabel!
    
    @IBOutlet fileprivate weak var numberOfListeningView: UIView!
    @IBOutlet fileprivate weak var durationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradientLayer(forView: numberOfListeningView)
        addGradientLayer(forView: durationView)
    }
    
    fileprivate func addGradientLayer(forView view: UIView) {
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
