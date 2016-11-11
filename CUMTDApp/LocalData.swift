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
    static let userDefaults = UserDefaults.standard
    
    /// Adds a new favorite stop
    ///
    /// - Parameter stop: the stop object
    static func addFavoriteStop(stop: Stop) {
        var favoriteStops = getFavoriteStops()
        if favoriteStops == nil {
            favoriteStops = [stop.id: stop.name]
        } else {
            favoriteStops?.setValue(stop.name, forKey: stop.id)
        }
        saveFavoriteStops(favoriteStops: favoriteStops)
    }
    
    /// Removes a stop from the favorite stops list
    ///
    /// - Parameter stopId: the stop id to remove
    static func removeFavoriteStop(stopId: String) {
        let favoriteStops = getFavoriteStops()
        if favoriteStops != nil {
            favoriteStops?.removeObject(forKey: stopId)
            saveFavoriteStops(favoriteStops: favoriteStops)
        }
    }
    
    /// Checks if the stop with the passed in stop id is marked as favorite
    ///
    /// - Parameter stopId: the stop id
    /// - Returns: True if the stop is marked as favorite, false otherwise
    static func isFavoriteStop(stopId: String) -> Bool {
        let favoriteStops = getFavoriteStops()
        if favoriteStops != nil {
            return favoriteStops![stopId] != nil
        } else {
            return false
        }
    }
    
    /// Gets a list of all the favorite stops
    ///
    /// - Returns: Mutable dictionary with the favorite stops
    static func getFavoriteStops() -> NSMutableDictionary? {
        let favorites = self.userDefaults.object(forKey: self.favoriteStopKey) as? NSMutableDictionary
        if favorites == nil {
            return nil
        }
        return favorites?.mutableCopy() as! NSMutableDictionary?
    }
    
    /// helper function that saves the changes to the local data
    ///
    /// - Parameter favoriteStops: the new object to be saved
    static private func saveFavoriteStops(favoriteStops: NSMutableDictionary?) {
        self.userDefaults.set(favoriteStops, forKey: self.favoriteStopKey)
        self.userDefaults.synchronize()
    }
}
