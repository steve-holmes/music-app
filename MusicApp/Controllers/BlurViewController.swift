//
//  BlurViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/25/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class BlurViewController: UIViewController {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var circleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVolumeSlider()
        setupCircleImageView()
    }
    
    private func setupVolumeSlider() {
        var image = UIImage.imageWithColor(UIColor.greenColor(), withSize: CGSize(width: 80, height: 32))
        image = image.imageWithRadius(16, byRoundingCorners: [.TopRight, .BottomLeft])
        volumeSlider.setThumbImage(image, forState: .Normal)
        
        volumeSlider.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        volumeSlider.continuous = false
        
        volumeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func sliderValueChanged(slider: UISlider) {
        print(slider.value)
    }
    
    private func setupCircleImageView() {
        var circleImage = UIImage.imageWithColor(UIColor.whiteColor(), withSize: circleImageView.bounds.size)
        circleImage = circleImage.imageWithRadius(circleImageView.bounds.size.width / 2)
        
        let playImage = UIImage(named: "Play")!
        circleImage = circleImage.imageWithoutInnerImage(playImage, inRect: CGRect(
            x: circleImage.size.height / 4,
            y: circleImage.size.width / 4,
            width: circleImage.size.width / 2,
            height: circleImage.size.height / 2
        ))
        
        circleImageView.image = circleImage
    }

}
