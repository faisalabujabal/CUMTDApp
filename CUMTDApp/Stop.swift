//
//  Stop.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Class representation of a Stop
class Stop: NSObject, NSCoding {
    var id: String
    var name: String
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
        self.isFavorite = LocalData.isFavoriteStop(stopId: self.id)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.isFavorite, forKey: "isFavorite")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.isFavorite = aDecoder.decodeObject(forKey: "isFavorite") as! Bool
    }
    
}
