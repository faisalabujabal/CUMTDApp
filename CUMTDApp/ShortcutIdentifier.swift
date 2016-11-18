//
//  ShortcutIdentifier.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/18/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

/// Enum class that keeps track of the app shortcuts
enum ShortcutIdentifier: String {
    case nearbyShortcut = "faisal-oscar.cumtd.nearbyShortcutItem"
    case favoritesShortcut = "faisal-oscar.cumtd.favoritesShortcutItem"
    
    func getTabBarIndex() -> Int {
        switch self {
        case .favoritesShortcut:
            return 0
        case .nearbyShortcut:
            return 1
        }
    }
}
