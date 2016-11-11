//
//  Route.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Represents a Route
class Route {
    var headsign: String
    var expectedMin: Int
    var isIStop: Bool
    var color: String
    
    /// Initializes a Route from the API data
    ///
    /// - Parameter data: the response from the API
    init(data: NSDictionary) {
        self.headsign = (data["headsign"] as? String)!
        self.expectedMin = (data["expected_mins"] as? NSInteger)!
        self.isIStop = (data["is_istop"] as? Bool)!
        self.color = ((data["route"] as? NSDictionary)?["route_color"] as? String)!
    }
}
