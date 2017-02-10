//
//  RoutesInterfaceController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 12/2/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import WatchKit

class RoutesInterfaceController: WKInterfaceController {

    var stop: Stop? = nil
    var routes: [Route] = []
    var emptyStateMessage: String = "Loading..."
    
    @IBOutlet var routesTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.stop = context as? Stop
        
        if self.stop != nil {
            initalizeRoutesTable()
            reloadTableData()
        }
    }
    
    /// initializes the table for the routes
    private func initalizeRoutesTable() {
        if self.stop != nil {
            Api.getRoutes(stopId: (self.stop!.id)) { (response) -> () in
                DispatchQueue.main.async {
                    if response == nil {
                        self.emptyStateMessage = "Network Error 😣"
                    } else {
                        self.routes = Parser.parseRoutes(data: response!)
                        if self.routes.count == 0 {
                            self.emptyStateMessage = "No routes at the moment 😱"
                        }
                    }
                    self.reloadTableData()
                }
            }
        }
    }
    
    /// Reloads the table data, counter and info
    private func reloadTableData() {
        let numRows = max(self.routes.count, 1)
        self.routesTable.setNumberOfRows(numRows, withRowType: "routeRow")
        setUpRows()
    }
    
    /// helper function that adds the data to the table
    private func setUpRows() {
        if self.routes.count > 0 {
            for rowIndex in 0...self.routes.count - 1 {
                let tableRow = routesTable.rowController(at: rowIndex) as! RouteRow
                let currentRow = self.routes[rowIndex]
                tableRow.routeName.setText(currentRow.headsign)
                tableRow.remainingTime.setText(String(currentRow.expectedMin) + " min")
            }
        } else {
            let tableRow = routesTable.rowController(at: 0) as! RouteRow
            tableRow.routeName.setText(self.emptyStateMessage)
            tableRow.remainingTime.setText("")
        }
    }

}
