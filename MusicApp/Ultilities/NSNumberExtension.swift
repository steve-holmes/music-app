//
//  NSNumberExtension.swift
//  MusicApp
//
//  Created by HungDo on 8/24/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
}

protocol DoubleConvertible {
    init(_ double: Double)
    var double: Double { get }
}

extension Double:  DoubleConvertible { var double: Double { return self } }
extension Float:   DoubleConvertible { var double: Double { return Double(self) } }

extension DoubleConvertible {
    
    var degreesToRadians: DoubleConvertible {
        return Self(double * M_PI / 180)
    }
    
    var radiansToDegrees: DoubleConvertible {
        return Self(double * 180 / M_PI)
    }
    
}