//
//  RouteCell.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {
    
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    
    public func updateCellColors(hexBackgroundColor: String) {
        let backgroundColorRGBA = RGBA(hex: hexBackgroundColor)
        self.backgroundColor = backgroundColorRGBA?.getUIColor()
        updateTextColor(textColor: getFontColor(backgroundColor: backgroundColorRGBA!))
    }
    
    private func updateTextColor(textColor: UIColor) {
        self.routeName.textColor = textColor
        self.remainingTime.textColor = textColor
    }
    
    private func getFontColor(backgroundColor: RGBA) -> UIColor {
        // source http://stackoverflow.com/questions/1855884/determine-font-color-based-on-background-color
        // Counting the perceptive luminance - human eye favors green color...
        let redIntensity = 0.299 * backgroundColor.red
        let greenIntensity = 0.587 * backgroundColor.green
        let blueIntensity = 0.114 * backgroundColor.blue
        let intensity = 1 - (redIntensity + greenIntensity + blueIntensity)/255
        
        var textColor: CGFloat = 0.0
        if (intensity < 0.5) {
            textColor = 0 // bright colors - black font
        } else {
            textColor = 255 // dark colors - white font
        }
        return UIColor(red: textColor, green: textColor, blue: textColor, alpha: 1.0)
    }
    
}
