//
//  SpotlightSearch.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 12/2/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

/// Static class to deal with the spotlight search
class SpotlightSearch {
    
    /// https://www.hackingwithswift.com/example-code/system/how-to-use-core-spotlight-to-index-content-in-your-app
    /// Adds a stop to the spotlight search index
    ///
    /// - Parameter stop: The set to add to the spotlight search
    static func addFavoriteStop(stop: Stop) {
        let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attrSet.title = stop.name
        
        let item = CSSearchableItem(uniqueIdentifier: stop.id, domainIdentifier: "faisal-oscar.CUMTDApp", attributeSet: attrSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Removes a stop to the spotlight search index
    ///
    /// - Parameter stopId: the stopId to remove
    static func removeFavoriteStop(stopId: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [stopId]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
