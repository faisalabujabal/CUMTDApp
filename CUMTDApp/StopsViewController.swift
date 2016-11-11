//
//  ViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/9/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit
import CoreLocation

/// Custom view controller for the stops view controller
class StopsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var stops: [Stop] = []
    
    @IBOutlet weak var stopsTableView: UITableView!
    
    /// function that gets called after the view gets loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopsTableView.delegate = self
        self.stopsTableView.dataSource = self
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
                self.stops = Parser.parseStops(data: response)
                self.stopsTableView.reloadData()
            }
        }
    }

    /// The content of every cell
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    /// - Returns: the cell that should be rendered
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stopListCell = tableView.dequeueReusableCell(withIdentifier: "stopCell", for: indexPath) as! StopCell
        let currentStop = self.stops[indexPath.row]
        stopListCell.stopFullName.text = currentStop.name
        stopListCell.stopId = currentStop.id
        return stopListCell
    }
    
    /// The number of table view rows
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - section: the section
    /// - Returns: the number of rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stops.count
    }
    
    /// When a segue transition will occur
    ///
    /// - Parameters:
    ///   - segue: the story board segue
    ///   - sender: the sender of the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stop = sender as! Stop
        let detailViewController = segue.destination as! RoutesViewController
        detailViewController.stop = stop
    }
    
    /// This function gets called when a row is selected
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRoutesFromStops", sender: self.stops[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

