//
//  StopDetailViewController.swift
//  CUMTDApp
//
//  Created by 莜欣|Oscar on 11/11/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import MapKit
import UIKit

class StopDetailViewController: UIViewController, MKMapViewDelegate{
    
    var stop : Stop? = nil
    @IBOutlet weak var mapView: MKMapView!
    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    /// Redraw the map and place a pin on it.
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.stop == nil {
            return
        }
        let stop = self.stop!
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: stop.location, span: span)

        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()

        annotation.coordinate = stop.location
        mapView.addAnnotation(annotation)


    }
    
    
}
