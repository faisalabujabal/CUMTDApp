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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteStops()
    }
    
    private func loadFavoriteStops() {
        if self.tableViewController != nil {
            self.favoriteStops = []
            for (stopId, stopName) in LocalData.getFavoriteStops()! {
                let stopData = ["stop_id": stopId, "stop_name": stopName]
                favoriteStops.append(Stop(data: stopData as NSDictionary))
            }
            self.tableViewController?.stops = self.favoriteStops
            self.tableViewController?.refreshTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "fromFavoriteStopsNavController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tableViewController = segue.destination as? StopsViewController
        self.tableViewController?.stops = self.favoriteStops
        self.tableViewController?.title = "Favorites"
    }
}
