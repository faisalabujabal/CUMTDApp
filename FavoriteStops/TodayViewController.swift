//
//  TodayViewController.swift
//  FavoriteStops
//
//  Created by Faisal Abu Jabal on 11/17/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    var homeStop: Stop? = nil
    var homeStopRoutes: [Route] = []
    
    var universityStop: Stop? = nil
    var universityStopRoutes: [Route] = []
        
    @IBOutlet var homeStopTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        initializeTableViews()
        initializeStops()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeStopRoutes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeCell = tableView.dequeueReusableCell(withIdentifier: "widgetRouteCell", for: indexPath) as! RouteCell
        let currentRoute = self.homeStopRoutes[indexPath.row]
        routeCell.routeName.text = currentRoute.headsign
        routeCell.remainingTime.text = "\(currentRoute.expectedMin) min"
        routeCell.updateCellColors(hexBackgroundColor: currentRoute.color)
        return routeCell
    }
    
    private func initializeTableViews() {
        self.homeStopTableView.dataSource = self
        self.homeStopTableView.delegate = self
    }
    
    private func initializeStops() {
        self.homeStop = LocalData.getWidgetStop(for: WidgetStopType.homeStop)
        
        if self.homeStop != nil {
            Api.getRoutes(stopId: (self.homeStop?.id)!, completionHandler: { (response) in
                self.homeStopRoutes = Parser.parseRoutes(data: response)
                self.homeStopTableView.reloadData()
            })
        }
        
        self.universityStop = LocalData.getWidgetStop(for: WidgetStopType.universityStop)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
