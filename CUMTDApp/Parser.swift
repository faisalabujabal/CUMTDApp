//
//  Parser.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Static class that parses the data from the API
class Parser {
    
    /// Parses the stop dictionaries to array of Stops
    ///
    /// - Parameter data: response returned from the API
    /// - Returns: array of stops
    static func parseStops(data: [NSDictionary]) -> [Stop] {
        var stops: [Stop] = []
        for stopData in data {
            stops.append(Stop(data: stopData))
        }
        return stops
    }
    
    /// Parses the Routes dictionaries to array of Routes
    ///
    /// - Parameter data: response returned from the API
    /// - Returns: array of Routes
    static func parseRoutes(data: [NSDictionary]) -> [Route] {
        var routes: [Route] = []
        for routeData in data {
            routes.append(Route(data: routeData))
        }
        return routes
    }
    
    static func parseLocalFavoriteStops(data: NSDictionary) -> [Stop] {
        var stops: [Stop] = []
        for (stopId, stopName) in data {
            stops.append(Stop(data: ["stop_id": stopId, "stop_name": stopName]))
        }
        return stops
    }
}
