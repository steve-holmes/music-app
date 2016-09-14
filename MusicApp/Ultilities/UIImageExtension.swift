//
//  UIImageExtension.swift
//  MusicApp
//
//  Created by HungDo on 8/22/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        draw(in: rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setBlendMode(.sourceIn)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithRadius(_ radius: CGFloat, byRoundingCorners corners: UIRectCorner? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        if let roundingCorners = corners {
            UIBezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius)).addClip()
        } else {
            UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        }
        
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithInnerImage(_ innerImage: UIImage, inRect rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsPushContext(context)
            innerImage.draw(in: rect)
            UIGraphicsPopContext()
        } else {
            innerImage.draw(in: rect)
        }
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithoutInnerImage(_ innerImage: UIImage, inRect rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        innerImage.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithInnerImage(_ innerImage: UIImage, atCenter center: CGPoint) -> UIImage {
        let rect = CGRect(
            x: center.x - innerImage.size.width / 2,
            y: center.y - innerImage.size.height / 2,
            width: innerImage.size.width,
            height: innerImage.size.height
        )
        return imageWithInnerImage(innerImage, inRect: rect)
    }
    
    func imageWithoutInnerImage(_ innerImage: UIImage, atCenter center: CGPoint) -> UIImage {
        let rect = CGRect(
            x: center.x - innerImage.size.width / 2,
            y: center.y - innerImage.size.height / 2,
            width: innerImage.size.width,
            height: innerImage.size.height
        )
        return imageWithoutInnerImage(innerImage, inRect: rect)
    }
    
    class func imageWithColor(_ color: UIColor, withSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
