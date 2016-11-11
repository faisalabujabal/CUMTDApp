//
//  NearbyStopsNavigationController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyStopsNavigationController: UINavigationController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var stops: [Stop] = []
    var performedSegue: Bool = false
    var stopsViewController: StopsViewController? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeLocationManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "fromNearbyStopsNavController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.stopsViewController = segue.destination as? StopsViewController
        self.stopsViewController?.stops = self.stops
        self.stopsViewController?.title = "Nearby"
        self.stopsViewController?.showIndicatorByDefault = true
    }
    
    /// initializes the location manager
    func initializeLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager?.requestLocation()
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    /// If getting the location fails
    ///
    /// - Parameters:
    ///   - manager: the location manager
    ///   - error: the error that occured
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error with getting the location")
    }
    
    /// If the location gets updated
    ///
    /// - Parameters:
    ///   - manager: the location manager
    ///   - locations: the new locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
        let lat = (self.currentLocation?.coordinate.latitude)! as Double
        let lon = (self.currentLocation?.coordinate.longitude)! as Double
        Api.getStops(lat: lat, lon: lon) {(response) -> () in
            DispatchQueue.main.async {
                self.stopsViewController?.stops = Parser.parseStops(data: response)
                self.stopsViewController?.refreshTableView()
                self.stopsViewController?.loadingIndicator.stopAnimating()
            }
        }
    }
}
