//
//  NetworkHelper.swift
//  LSFManager
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkHelper {
    
    /// Use this method to make a http request where the response should be a json file
    ///
    /// - Parameters:
    ///   - urlStr: The url where to get the JSON from
    ///   - callback: The callback method that will be called after the http request has been made.
    static func jsonRequest(urlStr: String, callback: @escaping (JSON?,CustomError?) -> Void){
        
        guard let url = URL(string: urlStr) else {
            // Return error for not being able to create url instance
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60

        Alamofire.request(request)
            .responseJSON { (response:DataResponse) in

                switch (response.result) {

                case .success(let data):
                    
                    let json = JSON(data)
                    
                    callback(json, nil)
                    
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        callback(false, CustomErrors.networkTimeoutError)
                    }else{
                        callback(false, CustomErrors.networkRequestFailure)
                    }
                    break
                }
        }
    }

}
