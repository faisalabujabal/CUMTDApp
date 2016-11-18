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

    var stops: [Stop?] = []
    var stopRoutes: [[Route]] = []
 
    @IBOutlet var homeStopTableView: UITableView!
    
    /// gets called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        initializeStyles()
        initializeTableViews()
        initializeStops()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }
    
    /// initializes the styles
    private func initializeStyles() {
        self.homeStopTableView.contentInset = UIEdgeInsetsMake(-25, 0, -25, 0);
    }
    
    /// The height between sections
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - section: the section integer
    /// - Returns: the space between sections
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    /// Returns the number of rows in a section
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - section: the section number
    /// - Returns: the number of rows in a section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.stopRoutes[section].count > 2) ? 2 : self.stopRoutes[section].count
    }
    
    /// Gets called to return the view cell
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path of the cell
    /// - Returns: the table cell to be rendered
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routeCell = tableView.dequeueReusableCell(withIdentifier: "widgetRouteCell", for: indexPath) as! RouteCell
        let currentRoute = self.stopRoutes[indexPath.section][indexPath.row]
        routeCell.routeName.text = currentRoute.headsign
        routeCell.remainingTime.text = "\(currentRoute.expectedMin) min"
        routeCell.updateCellColors(hexBackgroundColor: currentRoute.color)
        return routeCell
    }
    
    /// initializes the table view
    private func initializeTableViews() {
        self.homeStopTableView.dataSource = self
        self.homeStopTableView.delegate = self
    }
    
    /// Does network requests to initialize the stops
    private func initializeStops() {
        if let homeStop = LocalData.getWidgetStop(for: WidgetStopType.homeStop) {
            self.stops.append(homeStop)
        } else {
            self.stops.append(nil)
        }
        
        if let universityStop = LocalData.getWidgetStop(for: WidgetStopType.universityStop) {
            self.stops.append(universityStop)
        } else {
            self.stops.append(nil)
        }
        
        self.stopRoutes.append([])
        self.stopRoutes.append([])
        
        for stopIndex in 0...(self.stops.count - 1) {
            let stop = self.stops[stopIndex]
            if stop != nil {
                Api.getRoutes(stopId: (stop?.id)!, completionHandler: { (response) in
                    self.stopRoutes[stopIndex] = Parser.parseRoutes(data: response)
                    self.homeStopTableView.reloadData()
                })
            }
        }
    }
    
    /// Number of sections in the widget
    ///
    /// - Parameter tableView: the table view
    /// - Returns: the number of sections
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.stops.count
    }
    
    /// Returns the title of a section
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - section: the section number
    /// - Returns: the title of the section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.stops[section]?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// gets called when the widget is updated
    ///
    /// - Parameter completionHandler: when the function is completed
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    /// The height of the widget
    ///
    /// - Parameters:
    ///   - activeDisplayMode: the display mode
    ///   - maxSize: the max possible size
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
            self.homeStopTableView.reloadData()
        } else {
            self.preferredContentSize = CGSize(width: 0, height: 200);
        }
    }
    
}
