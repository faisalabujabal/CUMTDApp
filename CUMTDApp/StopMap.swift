//
//  StopMapView.swift
//  CUMTDApp
//
//  Created by 莜欣|Oscar on 11/11/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//
import MapKit
import UIKit

class StopMap: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
}
