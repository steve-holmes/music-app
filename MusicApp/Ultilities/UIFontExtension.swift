//
//  UIFontExtension.swift
//  MusicApp
//
//  Created by HungDo on 8/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

extension UIFont {
    
    func traits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func boldTrait() -> UIFont {
        return traits(.traitBold)
    }
    
    func regularTrait() -> UIFont {
        return traits()
    }
    
    class func avenirNextFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 17)!
    }
    
}
