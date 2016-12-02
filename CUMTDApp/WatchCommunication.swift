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
    
    /*
    func session(_ session: WCSession, didReceiveMessageData message: [String:Any], replyHandler: @escaping ([String : Any]) -> Void) {
        do {
            // let message = try JSONSerialization.jsonObject(with: message, options: []) as? [String: String]
            if (message["request"] as! String) == "favoriteStops" {
                replyHandler((LocalData.getFavoriteStops() as NSDictionary) as! [String:Any]) // NSKeyedArchiver.archivedData(withRootObject: LocalData.getFavoriteStops()))
            }
        } catch let error as NSError {
            print("heeeere")
            print(error.description)
        }
    }*/
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        sendMessageToWatch(favoriteStops: (LocalData.getFavoriteStops() as NSDictionary) as! [String:Any])
    }
    #endif

    public func requestFavoritesFromPhone(completionHandler: @escaping ([Stop]) -> ()) {
        if self.watchSession != nil {
            /* watchSession?.sendMessage(["request": "favoriteStops"], replyHandler: { (response) in
                let favoriteStops = Parser.parseLocalFavoriteStops(data: response as NSDictionary)
                completionHandler(favoriteStops)
             }, errorHandler: { (error) in
                print(error)
                completionHandler([])
             })*/
            watchSession?.sendMessage(["request": "favoriteStops"], replyHandler: { (Data) in
                print(Data)
            }, errorHandler: { (error) in
                print(error)
            })
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let favoriteStops = Parser.parseLocalFavoriteStops(data: applicationContext as NSDictionary)
        if messageReceivedHandler != nil {
            messageReceivedHandler!(favoriteStops)
        }
    }
}
