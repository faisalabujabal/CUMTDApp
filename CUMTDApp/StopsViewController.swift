//
//  ViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/9/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Custom view controller for the stops view controller
class StopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var stops: [Stop] = []
    
    @IBOutlet weak var stopsTableView: UITableView!
    
    /// function that gets called after the view gets loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopsTableView.delegate = self
        self.stopsTableView.dataSource = self
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
    
    public func refreshTableView() {
        if self.stopsTableView != nil {
            self.stopsTableView.reloadData()
        }
    }
}

