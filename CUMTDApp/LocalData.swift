//
//  LocalData.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// This class deals with the local data
class LocalData {
    static let favoriteStopKey: String = "favoriteStops"
    static let widgetStopKeys: [WidgetStopType: String] = [
        WidgetStopType.homeStop: "homeStop",
        WidgetStopType.universityStop: "universityStop"
    ]
    static let userDefaults = UserDefaults(suiteName: "group.cumtdapp")
    
    /// Adds a new favorite stop
    ///
    /// - Parameter stop: the stop object
    static func addFavoriteStop(stop: Stop) {
        let favoriteStops = getFavoriteStops()
        favoriteStops.setValue(stop.name, forKey: stop.id)
        saveFavoriteStops(favoriteStops: favoriteStops)
    }
    
    /// Removes a stop from the favorite stops list
    ///
    /// - Parameter stopId: the stop id to remove
    static func removeFavoriteStop(stopId: String) {
        let favoriteStops = getFavoriteStops()
        if isFavoriteStop(stopId: stopId) {
            favoriteStops.removeObject(forKey: stopId)
            saveFavoriteStops(favoriteStops: favoriteStops)
        }
    }
    
    /// Checks if the stop with the passed in stop id is marked as favorite
    ///
    /// - Parameter stopId: the stop id
    /// - Returns: True if the stop is marked as favorite, false otherwise
    static func isFavoriteStop(stopId: String) -> Bool {
        let favoriteStops = getFavoriteStops()
        return favoriteStops.value(forKey: stopId) != nil
    }
    
    /// Gets a list of all the favorite stops
    ///
    /// - Returns: Mutable dictionary with the favorite stops
    static func getFavoriteStops() -> NSMutableDictionary {
        let favorites = self.userDefaults?.object(forKey: self.favoriteStopKey) as? NSMutableDictionary
        if favorites == nil {
            return [:]
        }
        return favorites?.mutableCopy() as! NSMutableDictionary
    }
    
    /// helper function that saves the changes to the local data
    ///
    /// - Parameter favoriteStops: the new object to be saved
    static private func saveFavoriteStops(favoriteStops: NSMutableDictionary) {
        self.userDefaults?.set(favoriteStops, forKey: self.favoriteStopKey)
        self.userDefaults?.synchronize()
    }
    
    /// Updates the widget stop
    ///
    /// - Parameters:
    ///   - widgetStopType: the type of the widget stop
    ///   - stop: the stop
    static public func updateWidgetStop(for widgetStopType: WidgetStopType, stop: Stop) {
        self.userDefaults?.set(["stop_name": stop.name, "stop_id": stop.id], forKey: self.widgetStopKeys[widgetStopType]!)
    }
    
    static public func removeWidgetStop(for widgetStopType: WidgetStopType) {
        if self.userDefaults?.value(forKey: self.widgetStopKeys[widgetStopType]!) != nil {
            self.userDefaults?.removeObject(forKey: self.widgetStopKeys[widgetStopType]!)
        }
    }
    
    /// gets the widget stop
    ///
    /// - Parameter widgetStopType: the type of the widget stop
    /// - Returns: the stop based on the type
    static public func getWidgetStop(for widgetStopType: WidgetStopType) -> Stop? {
        let data = self.userDefaults?.value(forKey: self.widgetStopKeys[widgetStopType]!)
        if data == nil {
            return nil
        }
        return Stop(data: data as! NSDictionary)
    }

}
