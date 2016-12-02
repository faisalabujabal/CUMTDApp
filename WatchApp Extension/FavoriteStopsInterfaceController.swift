//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Faisal Abu Jabal on 12/2/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import WatchKit

class FavoriteStopsInterfaceController: WKInterfaceController {

    @IBOutlet var favoritesTable: WKInterfaceTable!
    var favoriteStops: [Stop] = []
    var watchCommunication: WatchCommunication? = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        initializeWatchCommunication()
        initializeFavoriteStopsTable()
    }
    
    override func willActivate() {
        super.willActivate()
        
        requestFavoritesFromPhone()
    }
    
    /// Initializes the favorites table with the count and data
    private func initializeFavoriteStopsTable() {
        let favoritesTableCount = max(self.favoriteStops.count, 1)
        self.favoritesTable.setNumberOfRows(favoritesTableCount, withRowType: "stopRow")
        setUpRows()
    }
    
    /// Helper function that adds the data to the table
    private func setUpRows() {
        if self.favoriteStops.count > 0 {
            for rowIndex in 0...self.favoriteStops.count - 1 {
                let tableRow = favoritesTable.rowController(at: rowIndex) as! StopRow
                let currentStop = self.favoriteStops[rowIndex]
                tableRow.stopName.setText(currentStop.name)
            }
        } else {
            let tableRow = favoritesTable.rowController(at: 0) as! StopRow
            tableRow.stopName.setText("No favorite stops ☹️")
        }
    }
    
    /// Sends a message to the phone to update the context
    private func requestFavoritesFromPhone() {
        self.watchCommunication?.requestFavoritesFromPhone(completionHandler: { (favoriteStops) in
            self.favoriteStops = favoriteStops
            self.initializeFavoriteStopsTable()
        })
    }
    
    /// Initializes the watch communication function to start sending and receiving
    private func initializeWatchCommunication() {
        self.watchCommunication = WatchCommunication()
        requestFavoritesFromPhone()
        
        self.watchCommunication!.addReceiveMessageObserver { (favoriteStops) in
            self.favoriteStops = favoriteStops
            self.initializeFavoriteStopsTable()
        }
    }

    /// Performs a segue to the route details
    ///
    /// - Parameters:
    ///   - segueIdentifier: the segue identifier
    ///   - table: the table
    ///   - rowIndex: the row that was pressed
    /// - Returns: the context for the next view
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if self.favoriteStops.count > 0 {
            return self.favoriteStops[rowIndex]
        }
        return nil
    }
}
