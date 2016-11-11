//
//  ViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/9/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Custom view controller for the stops view controller

class StopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    var stops: [Stop] = []
    var stopsSearchResult: [Stop] = []
    var shouldShowSearchResult: Bool = false;
    var searchController: UISearchController!
    var showIndicatorByDefault: Bool = false
    
    @IBOutlet weak var stopsTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    /// function that gets called after the view gets loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stopsTableView.delegate = self
        self.stopsTableView.dataSource = self
        configureSearchController()
        initializeStyles()
        
        if self.showIndicatorByDefault {
            self.loadingIndicator.startAnimating()
        }
    }
    
    func initializeStyles() {
        self.stopsTableView.separatorColor = UIColor.clear
    }
    
    /// setup the search controller
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
        stopsTableView.tableHeaderView = searchController.searchBar
        // add offset to hide the search bar by default
        stopsTableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height - stopsTableView.contentOffset.y)
    }
    
    /// filter the stops to display the matching result
    ///
    /// - Parameter searchText: the keyword user typed in to perform the search
    func filterContentForSearchText(searchText: String) -> Void {
        if self.stops.isEmpty {
            return
        }
        self.stopsSearchResult = self.stops.filter({ (currStop: Stop) -> Bool in
            return currStop.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    /// a delegate function that will be called when user types something in the search bar
    ///
    /// - Parameter searchController: the controller whose search bar is being manipulated
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        stopsTableView.reloadData()
    }
    
    /// delegate method being called when user start typing
    ///
    /// - Parameter searchBar: the bar user types into
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResult = true
        self.stopsTableView.reloadData()
        
    }
    
    /// delegate method being called when user hit cancel button
    ///
    /// - Parameter searchBar: the bar whose cancel button is clicked by user
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResult = false
        self.stopsTableView.reloadData()
    }

    /// The content of every cell
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    /// - Returns: the cell that should be rendered
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let stopListCell = tableView.dequeueReusableCell(withIdentifier: "stopCell", for: indexPath) as! StopCell
        let stopsList = shouldShowSearchResult ? self.stopsSearchResult : self.stops
        let currentStop = stopsList[indexPath.row]
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
        if shouldShowSearchResult {
            return self.stopsSearchResult.count
        }
        
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
        searchController.isActive = false
        
        performSegue(withIdentifier: "showRoutesFromStops", sender: self.stops[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)

        searchBarCancelButtonClicked(searchController.searchBar)
    }
    
    /// Helper function that refreshes the view
    public func refreshTableView() {
        if self.stopsTableView != nil {
            self.stopsTableView.reloadData()
        }
    }
}

