//
//  StopDetailsViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var stop: Stop? = nil
    var routes: [Route] = []
    

    @IBOutlet weak var routesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self
        
        intitializeStyles()
        
        Api.getRoutes(stopId: (self.stop?.id)!) { (response) -> () in
            DispatchQueue.main.async {
                self.routes = Parser.parseRoutes(data: response)
                self.routesTableView.reloadData()
            }
        }
    }
    
    private func intitializeStyles() {
        if self.stop != nil {
            self.title = self.stop?.name
        }
        self.routesTableView.separatorColor = UIColor.clear
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeCell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteCell
        let currentRoute = self.routes[indexPath.row]
        routeCell.routeName.text = currentRoute.headsign
        routeCell.remainingTime.text = "\(currentRoute.expectedMin) min"
        routeCell.updateCellColors(hexBackgroundColor: currentRoute.color)
        return routeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
