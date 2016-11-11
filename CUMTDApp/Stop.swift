//
//  Stop.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Class representation of a Stop
class Stop {
    var id: String
    var name: String
    
    /// Initializes a Stop
    ///
    /// - Parameter data: dictionary data
    init(data: NSDictionary) {
        self.id = (data["stop_id"] as? String)!
        self.name = (data["stop_name"] as? String)!
    }
}
