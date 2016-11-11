//
//  LocalData.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/10/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class LocalData {
    static let favoriteStopKey: String = "favoriteStops"
    static let userDefaults = UserDefaults.standard
    
    static func addFavoriteStop(stop: Stop) {
        var favoriteStops = getFavoriteStops()
        if favoriteStops == nil {
            favoriteStops = [stop.id: stop.name]
        } else {
            favoriteStops?.setValue(stop.name, forKey: stop.id)
        }
        saveFavoriteStops(favoriteStops: favoriteStops)
    }
    
    static func removeFavoriteStop(stopId: String) {
        let favoriteStops = getFavoriteStops()
        if favoriteStops != nil {
            favoriteStops?.removeObject(forKey: stopId)
            saveFavoriteStops(favoriteStops: favoriteStops)
        }
    }
    
    static func isFavoriteStop(stopId: String) -> Bool {
        let favoriteStops = getFavoriteStops()
        if favoriteStops != nil {
            return favoriteStops![stopId] != nil
        } else {
            return false
        }
    }
    
    static private func getFavoriteStops() -> NSMutableDictionary? {
        let favorites = self.userDefaults.object(forKey: self.favoriteStopKey) as? NSMutableDictionary
        if favorites == nil {
            return nil
        }
        return favorites?.mutableCopy() as! NSMutableDictionary?
    }
    
    static private func saveFavoriteStops(favoriteStops: NSMutableDictionary?) {
        self.userDefaults.set(favoriteStops, forKey: self.favoriteStopKey)
        self.userDefaults.synchronize()
    }
}
