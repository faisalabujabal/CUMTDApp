//
//  RGBA.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Represents an RGBA color
class RGBA {
    var red: CGFloat
    var blue: CGFloat
    var green: CGFloat
    var alpha: CGFloat
    
    /// initializes an RGBA Color from blue, green, red, and alpha
    ///
    /// - Parameters:
    ///   - red: the red color
    ///   - blue: the blue color
    ///   - green: the green color
    ///   - alpha: the alpha
    init(red: CGFloat, blue: CGFloat, green: CGFloat, alpha: CGFloat) {
        self.red = red
        self.blue = blue
        self.green = green
        self.alpha = alpha
    }
    
    /// initializes an RGBA Color from the hex representation
    ///
    /// source http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
    ///
    /// - Parameters:
    ///   - hex: the hex representation
    convenience init?(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /// Returns the UIColor of the RGBA Color
    ///
    /// - Returns: the UIColor representation
    func getUIColor() -> UIColor {
        return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
}
