//
//  Stop.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit
import MapKit


/// Class representation of a Stop
class Stop {
    var id: String
    var name: String
    var location : CLLocationCoordinate2D
    var isFavorite: Bool
    
    /// Initializes a Stop
    ///
    /// - Parameter data: dictionary data
    init(data: NSDictionary) {
        self.id = (data["stop_id"] as? String)!
        if data.value(forKey: "stop_name") != nil {
            self.name = (data["stop_name"] as? String)!
        } else if data.value(forKey: "name") != nil {
            self.name = (data["name"] as? String)!
        } else {
            self.name = ""
        }
        
        #if os(iOS)
            self.isFavorite = LocalData.isFavoriteStop(stopId: self.id)
        #else       // we don't care about isFavorite on the watch
            self.isFavorite = false
        #endif
        
        let stop_points = data["stop_points"] as? [NSDictionary]
        let lon = stop_points?[0]["stop_lon"] as? Double
        let lat = stop_points?[0]["stop_lat"] as? Double
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat ?? 0), longitude: CLLocationDegrees(lon ?? 0))
    }
    
}
