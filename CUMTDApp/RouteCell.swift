//
//  RouteCell.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Custom table view cell for the route cell
class RouteCell: UITableViewCell {
    
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    
    /// Updates the background and text colors
    ///
    /// - Parameter hexBackgroundColor: the background color in hex
    public func updateCellColors(hexBackgroundColor: String) {
        let backgroundColorRGBA = RGBA(hex: hexBackgroundColor)
        self.backgroundColor = backgroundColorRGBA?.getUIColor()
        updateTextColor(textColor: getFontColor(backgroundColor: backgroundColorRGBA!))
    }
    
    /// helper function that updates the text colors based on the background
    ///
    /// - Parameter textColor: the new text color
    private func updateTextColor(textColor: UIColor) {
        self.routeName.textColor = textColor
        self.remainingTime.textColor = textColor
    }
    
    /// Returns a text color based on the background color
    ///
    /// - Parameter backgroundColor: the background color
    /// - Returns: the text color
    private func getFontColor(backgroundColor: RGBA) -> UIColor {
        // source http://stackoverflow.com/questions/1855884/determine-font-color-based-on-background-color
        // Counting the perceptive luminance - human eye favors green color...
        let intensity = 1 - ( 0.299 * backgroundColor.red +
            0.587 * backgroundColor.green + 0.114 * backgroundColor.blue)/255;
        
        var textColor: CGFloat = 0.0
        if (intensity < 0.5) {
            textColor = CGFloat(0) // bright colors - black font
        } else {
            textColor = CGFloat(255) // dark colors - white font
        }
        return UIColor(red: textColor, green: textColor, blue: textColor, alpha: 1.0)
    }
    
}
