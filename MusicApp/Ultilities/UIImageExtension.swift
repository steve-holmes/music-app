//
//  UIImageExtension.swift
//  MusicApp
//
//  Created by HungDo on 8/22/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        drawInRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetBlendMode(context, .SourceIn)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageWithRadius(radius: CGFloat, byRoundingCorners corners: UIRectCorner? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        if let roundingCorners = corners {
            UIBezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius)).addClip()
        } else {
            UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        }
        
        self.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageWithInnerImage(innerImage: UIImage, inRect frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        drawInRect(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsPushContext(context)
            innerImage.drawInRect(frame)
            UIGraphicsPopContext()
        } else {
            innerImage.drawInRect(frame)
        }
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageWithoutInnerImage(innerImage: UIImage, inRect frame: CGRect) -> UIImage {
        let image = innerImage.imageWithColor(UIColor.clearColor())
        return imageWithInnerImage(image, inRect: frame)
    }
    
    func imageWithInnerImage(innerImage: UIImage, atCenter center: CGPoint) -> UIImage {
        let rect = CGRect(
            x: center.x - innerImage.size.width / 2,
            y: center.y - innerImage.size.height / 2,
            width: innerImage.size.width,
            height: innerImage.size.height
        )
        return imageWithInnerImage(innerImage, inRect: rect)
    }
    
    func imageWithoutInnerImage(innerImage: UIImage, atCenter center: CGPoint) -> UIImage {
        let rect = CGRect(
            x: center.x - innerImage.size.width / 2,
            y: center.y - innerImage.size.height / 2,
            width: innerImage.size.width,
            height: innerImage.size.height
        )
        return imageWithoutInnerImage(innerImage, inRect: rect)
    }
    
    class func imageWithColor(color: UIColor, withSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}