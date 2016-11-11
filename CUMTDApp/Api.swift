//
//  Api.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/9/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class Api {
    static let apiPath: String = "https://secure-cove-26997.herokuapp.com/api"
    
    static func getStops(lat: Double, lon: Double, completionHandler: @escaping ([NSDictionary]) -> ()) {
        let params: (NSDictionary) = [
            "lat": lat,
            "lon": lon
        ]
        requestFromApi(endpoint: "get_stops", params: params, completionHandler: completionHandler)
    }
    
    static func getRoutes(stopId: String, completionHandler: @escaping ([NSDictionary]) -> ()) {
        let params: (NSDictionary) = [
            "stop_id": stopId
        ]
        requestFromApi(endpoint: "get_departure", params: params, completionHandler: completionHandler)
    }
    
    static private func requestFromApi(endpoint: String, params: NSDictionary,
                                       completionHandler: @escaping ([NSDictionary]) -> ()) {
        let queryParams = paramDictToString(params: params)
        let url = NSURL(string: "\(self.apiPath)/\(endpoint)?\(queryParams)")
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            if data != nil {
                let responseDictionary = try! JSONSerialization.jsonObject(with: data!) as? [NSDictionary]
                completionHandler(responseDictionary!)
            } else {
                completionHandler([])
            }
        }.resume()
    }
    
    static private func paramDictToString(params: NSDictionary) -> String {
        var queryString = ""
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        return queryString
    }
}
