//
//  Parser.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class Parser {
    
    static func parseStops(data: [NSDictionary]) -> [Stop] {
        var stops: [Stop] = []
        for stopData in data {
            stops.append(Stop(data: stopData))
        }
        return stops
    }
    
    static func parseRoutes(data: [NSDictionary]) -> [Route] {
        var routes: [Route] = []
        for routeData in data {
            routes.append(Route(data: routeData))
        }
        return routes
    }
}
