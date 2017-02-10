//
//  WatchCommunication.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 12/2/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchCommunication: NSObject, WCSessionDelegate {
    var watchSession: WCSession? = nil
    var messageReceivedHandler: (([Stop]) -> ())? = nil
    
    /// Initializer
    override init() {
        super.init()
        if(WCSession.isSupported()){
            self.watchSession = WCSession.default()
            self.watchSession?.delegate = self
            self.watchSession?.activate()
        }
    }
    
    /// Adds a function handler
    ///
    /// - Parameter actionHandler: the function handler
    public func addReceiveMessageObserver(actionHandler: @escaping ([Stop]) -> ()) {
        self.messageReceivedHandler = actionHandler
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // should be here for the protocol
    }
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        // should be here for the protoco
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    /// Updates the watch's info
    ///
    /// - Parameter favoriteStops: the new favorite stops
    public func sendMessageToWatch(favoriteStops: [String: Any]) {
        if self.watchSession != nil && self.watchSession!.isPaired && self.watchSession!.isWatchAppInstalled {
            do {
                try watchSession!.updateApplicationContext(favoriteStops)
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    #endif
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let favoriteStops = Parser.parseLocalFavoriteStops(data: applicationContext as NSDictionary)
        if messageReceivedHandler != nil {
            messageReceivedHandler!(favoriteStops)
        }
    }
}
