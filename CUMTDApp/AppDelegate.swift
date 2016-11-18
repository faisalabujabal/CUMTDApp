//
//  AppDelegate.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/9/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    /// Gets called when the app is opened through a shortcut
    ///
    /// - Parameters:
    ///   - application: the application
    ///   - shortcutItem: the shortcut used to open the app
    ///   - completionHandler: the completion status
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem: shortcutItem))
    }

    /// Handles the case if the app is opened from a shortcut
    ///
    /// - Parameter shortcutItem: the shortcut that opened the app
    /// - Returns: whether the app loaded successfully
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let type = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(rawValue: type) else {
            return false
        }
        
        if let tabBarViewController = self.window?.rootViewController as? UITabBarController {
            tabBarViewController.selectedIndex = shortcutIdentifier.getTabBarIndex()
        } else {
            return false
        }
        return true
    }

}

