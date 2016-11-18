//
//  SettingsTableViewController.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/17/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var widgetStopsTableView: UITableView!

    let widgetStops = [
        ["label": "Home Stop", "type": WidgetStopType.homeStop],
        ["label": "University Stop", "type": WidgetStopType.universityStop]
    ]
    let sectionTitles = ["Widget Stops"]
    let sectionFooterTitles = ["Stops to show on the widget."]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        widgetStopsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.widgetStopsTableView.dataSource = self
        self.widgetStopsTableView.delegate = self
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let widgetStopCell = tableView.dequeueReusableCell(withIdentifier: "widgetStopCell", for: indexPath) as! WidgetStopCell
        widgetStopCell.stopLabel.text = self.widgetStops[indexPath.row]["label"] as! String?
        widgetStopCell.widgetStopType = self.widgetStops[indexPath.row]["type"] as? WidgetStopType
        return widgetStopCell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.widgetStops.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sectionFooterTitles[section]
    }
    
    /// When a row gets clicked
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
