//
//  Api.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/9/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

/// Static class that deals with the API
class Api {
    static let apiPath: String = "https://secure-cove-26997.herokuapp.com/api"
    
    
    /// Returns the stops based on the location
    ///
    /// - Parameters:
    ///   - lat: the latitude location
    ///   - lon: the longitude location
    ///   - completionHandler: closure that gets called when the response gets back
    static func getStops(lat: Double, lon: Double, completionHandler: @escaping ([NSDictionary]?) -> ()) {
        let params: (NSDictionary) = [
            "lat": lat,
            "lon": lon
        ]
        requestFromApi(endpoint: "get_stops", params: params, completionHandler: completionHandler)
    }
    
    static func getStops(searchTerm: String, completionHandler: @escaping ([NSDictionary]?) -> ()) {
        let params = [
            "query": searchTerm
        ]
        requestFromApi(endpoint: "get_stops", params: params as NSDictionary, completionHandler: completionHandler)
    }
    
    /// Returns the routes based on the stopId
    ///
    /// - Parameters:
    ///   - stopId: the stop id for the routes
    ///   - completionHandler: closure that gets called when the response gets back
    static func getRoutes(stopId: String, completionHandler: @escaping ([NSDictionary]?) -> ()) {
        let params: (NSDictionary) = [
            "stop_id": stopId
        ]
        requestFromApi(endpoint: "get_departure", params: params, completionHandler: completionHandler)
    }
    
    /// Helper function that executes get requests to the api
    ///
    /// - Parameters:
    ///   - endpoint: the endpoint to get the data from
    ///   - params: dictionary parameters
    ///   - completionHandler: closure that gets called when the response gets back
    static private func requestFromApi(endpoint: String, params: NSDictionary,
                                       completionHandler: @escaping ([NSDictionary]?) -> ()) {
        let queryParams = paramDictToString(params: params)
        let requestString = "\(self.apiPath)/\(endpoint)?\(queryParams)"
        let escapedAddress = requestString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: escapedAddress!)
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            if data != nil {
                let responseDictionary = try! JSONSerialization.jsonObject(with: data!) as? [NSDictionary]
                completionHandler(responseDictionary!)
            } else if err != nil {
                completionHandler(nil)
            } else {
                completionHandler([])
            }
        }.resume()
    }
    
    /// Helper function that generate query params string from a dictionary
    ///
    /// - Parameter params: dictionary list of parameters
    /// - Returns: a string representation of the params
    static private func paramDictToString(params: NSDictionary) -> String {
        var queryString = ""
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        return queryString
    }
}
