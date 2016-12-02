//
//  NearbyStopsInterfaceController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 12/2/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class NearbyStopsInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var emptyStateMessage: String = "Loading..."
    var nearbyStops: [Stop] = []

    @IBOutlet var stopsTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        reloadTableData()
    }
    
    override func willActivate() {
        super.willActivate()
        
        initializeLocationManager()
    }
    
    /// initializes the location manager
    func initializeLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager?.requestLocation()
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    /// reloads the table data
    private func reloadTableData() {
        let numRows = max(self.nearbyStops.count, 1)
        self.stopsTable.setNumberOfRows(numRows, withRowType: "stopRow")
        setUpRows()
    }
    
    /// helper function that sets up the data
    private func setUpRows() {
        if self.nearbyStops.count > 0 {
            for rowIndex in 0...self.nearbyStops.count - 1 {
                let tableRow = self.stopsTable.rowController(at: rowIndex) as! StopRow
                let currentRow = self.nearbyStops[rowIndex]
                tableRow.stopName.setText(currentRow.name)
            }
        } else {
            let tableRow = self.stopsTable.rowController(at: 0) as! StopRow
            tableRow.stopName.setText(self.emptyStateMessage)
        }
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
                if response == nil {
                    self.emptyStateMessage = "Network error 😣"
                } else {
                    let stops =  Parser.parseStops(data: response!)
                    self.nearbyStops = stops
                    if self.nearbyStops.count == 0 {
                        self.emptyStateMessage = "No nearby stops 😱"
                    }
                }
                self.reloadTableData()
            }
        }
    }
    
    /// If getting the location fails
    ///
    /// - Parameters:
    ///   - manager: the location manager
    ///   - error: the error that occured
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("error with getting the location")
    }
    
    /// Performs a segue to the route details
    ///
    /// - Parameters:
    ///   - segueIdentifier: the segue identifier
    ///   - table: the table
    ///   - rowIndex: the index that was clicked
    /// - Returns: the context
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if self.nearbyStops.count > 0 {
            return self.nearbyStops[rowIndex]
        }
        return nil
    }

}
