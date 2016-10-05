//
//  Devices.swift
//  MusicApp
//
//  Created by HungDo on 9/22/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

struct ScreenSize {
    static let screenWidth          = UIScreen.main.bounds.size.width
    static let screenHeight         = UIScreen.main.bounds.size.height
    static let screenMaxLength      = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength      = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhone5              = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone6              = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone6Plus          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPad                 = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.screenMaxLength == 1024.0
    static let iPadPro              = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.screenMaxLength == 1366.0
}
