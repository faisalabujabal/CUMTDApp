//
//  StopDetailsViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Custom view controller for the routes view controller
class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var stop: Stop? = nil
    var routes: [Route] = []
    
    @IBOutlet weak var routesTableView: UITableView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func favoriteRouteAction(_ sender: UIButton) {
        if self.stop != nil {
            if (stop?.isFavorite)! {
                LocalData.removeFavoriteStop(stopId: self.stop!.id)
                self.stop?.isFavorite = false
            } else {
                LocalData.addFavoriteStop(stop: self.stop!)
                self.stop?.isFavorite = true
            }
            updateStarIcon()
        }
    }
    
    /// Gets called when the view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self
        
        intitializeStyles()
        self.loadingIndicator.startAnimating()
        
        Api.getRoutes(stopId: (self.stop?.id)!) { (response) -> () in
            DispatchQueue.main.async {
                self.routes = Parser.parseRoutes(data: response)
                self.routesTableView.reloadData()
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    /// initializes the stles for the view controller
    private func intitializeStyles() {
        if self.stop != nil {
            self.title = self.stop?.name
        }
        self.routesTableView.separatorColor = UIColor.clear
        updateStarIcon()
    }
    
    /// Get the number of rows
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - section: the section
    /// - Returns: the number of rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    /// The row content
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    /// - Returns: the route cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeCell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteCell
        let currentRoute = self.routes[indexPath.row]
        routeCell.routeName.text = currentRoute.headsign
        routeCell.remainingTime.text = "\(currentRoute.expectedMin) min"
        routeCell.updateCellColors(hexBackgroundColor: currentRoute.color)
        return routeCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? StopDetailViewController{
            nextViewController.stop = self.stop
            nextViewController.title = self.stop?.name
            
        }
    }

    
    /// When a row gets clicked
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Changes the favorite icon based on if the stop is favorite or not
    private func updateStarIcon() {
        if (stop?.isFavorite)! {
            self.favoriteBtn.setBackgroundImage(UIImage(named: "starIconFilled"), for: UIControlState.normal)
        } else {
            self.favoriteBtn.setBackgroundImage(UIImage(named: "starIcon"), for: UIControlState.normal)
        }
    }
    
}
