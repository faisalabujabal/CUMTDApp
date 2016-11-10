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
        let url = NSURL(string: "\(self.apiPath)/get_stops?lat=\(lat)&lon=\(lon)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        // var apiResponse: [NSDictionary] = []
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                let responseDictionary = try! JSONSerialization.jsonObject(with: data) as? [NSDictionary]
                completionHandler(responseDictionary!)
            } else {
                completionHandler([])
            }
        })
        task.resume()
    }
}
