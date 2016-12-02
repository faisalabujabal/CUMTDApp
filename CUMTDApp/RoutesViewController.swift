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
    var refreshController: UIRefreshControl = UIRefreshControl()
    var emptyStateMessage: String = ""
    
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
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        intitializeStyles()
        initializeRefreshController()
        self.loadingIndicator.startAnimating()
        loadData()
    }
    
    func didBecomeActive() {
        self.routesTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("dfsdf")
    }
    
    func willEnterForeground() {
        print("sdfasfadf")
    }
    
    /// Initialzes the UIRefreshControl and adds it to the view
    private func initializeRefreshController() {
        self.refreshController.addTarget("refresh", action: #selector(loadData), for: UIControlEvents.valueChanged)
        self.routesTableView.addSubview(self.refreshController)
    }
    
    /// Loads the data from the api
    @objc private func loadData() {
        Api.getRoutes(stopId: (self.stop?.id)!) { (response) -> () in
            DispatchQueue.main.async {
                if response == nil {
                    self.emptyStateMessage = "Network Error 😣"
                } else {
                    self.routes = Parser.parseRoutes(data: response!)
                    if self.routes.count == 0 {
                        self.emptyStateMessage = "No routes at the moment 😱"
                    }
                }
                self.routesTableView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.refreshController.endRefreshing()
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
        let count = self.routes.count
        if count == 0 {
            self.routesTableView.backgroundView = EmptyState.getEmptyStateView(reason: emptyStateMessage)
        } else {
            self.routesTableView.backgroundView = nil
            self.emptyStateMessage = ""
        }
        return count
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
