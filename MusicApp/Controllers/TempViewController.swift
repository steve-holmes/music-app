//
//  TempViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/22/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var anotherView: UIView!
    
    @IBAction func buttonTapped(button: CircleButton) {
        animatedView.alpha = 1
        anotherView.alpha = 1
        setupAnimatedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
    }
    
    func setupBackgroundImage() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundImageView.bounds
        backgroundImageView.layer.addSublayer(gradientLayer)
        
        gradientLayer.colors = [
            UIColor.redColor().colorWithAlphaComponent(0.5).CGColor,
            UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        ]
        
        gradientLayer.startPoint = CGPointZero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
    
    private func setupAnimatedView() {
        UIView.animateWithDuration(1,
            delay: 0,
            options: .CurveLinear,
            animations: {
                let xform = CGAffineTransformMakeRotation(CGFloat((-180).degreesToRadians.double))
                self.animatedView.transform = xform
                
                let layerAnimation = CABasicAnimation(keyPath: "transform")
                layerAnimation.duration = 2
                layerAnimation.beginTime = 0
                layerAnimation.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
                layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                layerAnimation.fromValue = 0.0
                layerAnimation.toValue = 360.degreesToRadians.double
                layerAnimation.byValue = 180.degreesToRadians.double
                
                self.animatedView.layer.addAnimation(layerAnimation, forKey: "layerAnimation")
            },
            completion: { completed in
                UIView.animateWithDuration(
                    1,
                    delay: 0,
                    options: .CurveLinear,
                    animations: {
                        let xform = CGAffineTransformMakeRotation(CGFloat((-359).degreesToRadians.double))
                        self.animatedView.transform = xform
                    },
                    completion: { completed in
                        self.animatedView.transform = CGAffineTransformIdentity
                    }
                )
            }
        )
    }
    
//    private func setupAnimatedView() {
//        UIView.animateWithDuration(
//            1,
//            delay: 1,
//            options: .CurveEaseOut,
//            animations: {
//                self.animatedView.alpha = 0
//                
//                UIView.animateWithDuration(
//                    0.2,
//                    delay: 0,
//                    options: [
//                        UIViewAnimationOptions.OverrideInheritedCurve,
//                        UIViewAnimationOptions.CurveLinear,
//                        UIViewAnimationOptions.OverrideInheritedDuration,
//                        UIViewAnimationOptions.Repeat,
//                        UIViewAnimationOptions.Autoreverse
//                    ],
//                    animations: {
//                        UIView.setAnimationRepeatCount(2.5)
//                        self.anotherView.alpha = 0
//                    }, completion: nil
//                )
//            },
//            completion: nil
//        )
//    }

}
