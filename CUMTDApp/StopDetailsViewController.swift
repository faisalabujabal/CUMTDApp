//
//  StopDetailsViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class StopDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var stop: Stop? = nil
    var routes: [Route] = []
    
    @IBOutlet weak var routesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routesTableView.delegate = self
        routesTableView.dataSource = self
        
        intitializeStyles()
        
        Api.getRoutes(stopId: (self.stop?.id)!) { (response) -> () in
            DispatchQueue.main.async {
                self.routes = Parser.parseRoutes(data: response)
                self.routesTableView.reloadData()
            }
        }
    }
    
    private func intitializeStyles() {
        if stop != nil {
            self.title = self.stop?.name
        }
        self.routesTableView.separatorColor = UIColor.clear
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeCell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteCell
        let currentRoute = self.routes[indexPath.row]
        let backgroundColor = getRouteCellColor(hexColor: currentRoute.color)
        let rgba = getRGBAFromHex(hex: currentRoute.color)
        routeCell.backgroundColor = backgroundColor
        routeCell.routeName.text = currentRoute.headsign
        routeCell.routeName.textColor = getFontColor(backgroundColor: rgba)
        routeCell.remainingTime.text = "\(currentRoute.expectedMin) min"
        routeCell.remainingTime.textColor = getFontColor(backgroundColor: rgba)
        return routeCell
    }
    
    private func getRouteCellColor(hexColor: String) -> UIColor {
        let rgba = getRGBAFromHex(hex: hexColor)
        return UIColor(red: (rgba["red"] as! CGFloat),
                       green: (rgba["green"] as! CGFloat),
                       blue: (rgba["blue"] as! CGFloat),
                       alpha: (rgba["alpha"] as! CGFloat))
    }
    
    private func getFontColor(backgroundColor: NSDictionary) -> UIColor {
        // source http://stackoverflow.com/questions/1855884/determine-font-color-based-on-background-color
        var d: CGFloat = 0.0
        // Counting the perceptive luminance - human eye favors green color...
        let redIntensity = 0.299 * (backgroundColor["red"] as! CGFloat)
        let greenIntensity = 0.587 * (backgroundColor["green"] as! CGFloat)
        let blueIntensity = 0.114 * (backgroundColor["blue"] as! CGFloat)
        let a = 1 - (redIntensity + greenIntensity + blueIntensity)/255
        
        if (a < 0.5) {
            d = 0 // bright colors - black font
        } else {
            d = 255 // dark colors - white font
        }
        return UIColor(red: d, green: d, blue: d, alpha: 1.0)
    }
    
    private func getRGBAFromHex(hex: String) -> NSDictionary {
        // source http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return [:]
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return [
            "red": CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            "green": CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            "blue": CGFloat(rgbValue & 0x0000FF) / 255.0,
            "alpha": CGFloat(1.0)
        ]
    }
}
