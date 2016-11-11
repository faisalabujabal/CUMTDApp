//
//  FavoriteStopsNavigationViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class FavoriteStopsNavigationController: UINavigationController {
    var favoriteStops: [Stop] = []
    var tableViewController: StopsViewController? = nil
    
    /// this function gets called before the view shows up
    ///
    /// - Parameter animated: the animation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteStops()
    }
    
    /// this function loads the favorite stops from the local data
    private func loadFavoriteStops() {
        if self.tableViewController != nil {
            self.favoriteStops = []
            let favorites = LocalData.getFavoriteStops()
            if favorites == nil {
                return
            }
            for (stopId, stopName) in favorites! {
                let stopData = ["stop_id": stopId, "stop_name": stopName]
                self.favoriteStops.append(Stop(data: stopData as NSDictionary))
            }
            self.tableViewController?.stops = self.favoriteStops
            self.tableViewController?.refreshTableView()
        }
    }
    
    /// this function gets called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "fromFavoriteStopsNavController", sender: nil)
    }
    
    /// this function gets called before the segue executes
    ///
    /// - Parameters:
    ///   - segue: the segue
    ///   - sender: the sender of the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tableViewController = segue.destination as? StopsViewController
        self.tableViewController?.stops = self.favoriteStops
        self.tableViewController?.title = "Favorites"
    }
}
