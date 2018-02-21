//
//  APIManager.swift
//  LSFManager
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// The API Manager basically takes care of the interaction between
/// APP and API. It has different asynchronous methods that do specific
/// Tasks.
class APIManager {
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////           Singleton Class Implementation           /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    static let sharedInstance = APIManager()
    
    private init(){}
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////               API Manager properties               /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    var access_token: String?
    var public_address: String?
    var port: Int?
    
    // Cache
    var professorsCache = [Professor]()
    var eventsCache = [Event]()
    var appointmentsCache = [Appointment]()
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////             API Methods Implementation             /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                    AUTHENTICATION                  /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    /// Use the authenticate endpoint to request an access token.
    /// Access tokens expire after 60 min.
    func authenticate(username: String, password: String, callback: @escaping (_ accessToken: String?,_ error: CustomError?) -> Void ) {
        
        // Check if the address and port has been setup
        guard let apiAddress = getAPIAddress() else { callback(nil, CustomErrors.requestCreationError); return }
        
        jsonRequest(urlStr: "\(apiAddress)accesstoken", httpMethod: "POST",parameters: ["username":username, "password": password], completion: { json, error in
            
            if let err = error {
                callback(nil,err)
                return
            }
            
            if let json = json {
                callback(json["access_token"].stringValue, nil)
            }else{
                callback(nil,error)
            }
            
        })
    }
    
    /// Method to check the validity of an existing access token.
    ///
    /// - Parameters:
    ///   - callback: This callback method returns an error if the token is not valid.
    func checkAccessToken(callback: @escaping (CustomError?) -> Void){
        
        // Check if the address and port has been setup
        guard let apiAddress = getAPIAddress() else { callback(CustomErrors.requestCreationError); return }
        
        // Check if the access token has already been setup
        guard let access_token = self.access_token else { callback(CustomErrors.accessTokenNotProvidedError); return }
        
        jsonRequest(urlStr: "\(apiAddress)accesstoken/?accesstoken=\(access_token)", httpMethod: "GET", parameters: nil, completion: { json, error in
            
            if let err = error {
                callback(err)
                
                return
            }
            
            // Unwrap JSON
            if let json = json {
                if let valid = json["valid"].bool {
                    if(valid){
                       callback(nil)
                        
                    }else{ callback(CustomErrors.tokenNotValidError) }
                    
                }else{ callback(CustomErrors.tokenNotValidError) }
                
            }else{ callback(CustomErrors.jsonUnwrappingError) }
        })
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////           SCHEDULE OVERVIEW (Zeitskala)            /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    /// This is the method to get the information of the schedule that appears in
    /// the initial Schedule overview, it is basically made out of named intervals
    /// For example: from 2 Jan 2018 until 8 Jan 2018 is exam registration period.
    ///
    /// - Parameter callback: This Callback Method returns either 
    func getScheduleOverview(callback: @escaping ([ScheduleIntervalLayer]?, CustomError?) -> Void){
            
            // Check if the address and port has been setup
            guard let apiAddress = getAPIAddress() else { callback(nil,CustomErrors.requestCreationError); return }
            
            jsonRequest(urlStr: "\(apiAddress)scheduleoverview/", httpMethod: "GET", parameters: nil, completion: { json, error in
                
                if let err = error {
                    callback(nil, err)
                }else{
                    // Unwrap JSON
                    if let json = json {
                        
                        var layers = [ScheduleIntervalLayer]()
                        
                        // Loop through layer objects
                        for (_,object) in json {
                            if let layer = ScheduleIntervalLayer(json: object){
                                layers.append(layer)
                            }
                        }
                        callback(layers, nil)
                        
                        // Return nil if JSON could not be unwrapped
                    }else{
                        callback(nil, CustomErrors.jsonUnwrappingError)
                    }
                }
            })
        }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                   EVENTS (Lectures)                /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    /// Method to get the details of an event.
    ///
    /// - Parameters:
    ///   - byName: The name of part of the name to use as search criteria
    ///   - callback: This callback method returns either a list of events or an error.
    func getEvents(byEventID event_id: Int, callback: @escaping ([Event]?, CustomError?) -> Void){
        
        // Check if the address and port has been setup
        guard let apiAddress = getAPIAddress() else { callback(nil,CustomErrors.requestCreationError); return }
        
        // Check if the access token has already been setup
        guard let access_token = self.access_token else { callback(nil,CustomErrors.accessTokenNotProvidedError); return }
        
        jsonRequest(urlStr: "\(apiAddress)events/by-id/\(event_id)?accesstoken=\(access_token)", httpMethod: "GET", parameters: nil, completion: { json, error in
            
            if let err = error {
                callback(nil, err)
            }else{
                // Unwrap JSON
                if let json = json {
                    
                    var events = [Event]()
                    
                    // Loop through event objects
                    for (_,object) in json {
                        if let event = Event(json: object){
                            events.append(event)
                        }
                    }
                    callback(events, nil)
                    
                    // Return nil if JSON could not be unwrapped
                }else{
                    callback(nil, CustomErrors.jsonUnwrappingError)
                }
            }
        })
    }
    

    /// Method to search for events by name
    ///
    /// - Parameters:^
    ///   - byName: The name of part of the name to use as search criteria
    ///   - callback: This callback method returns either a list of events or an error.
    func getEvents(byName: String, callback: @escaping ([Event]?, CustomError?) -> Void){
        
        // Check if the address and port has been setup
        guard let apiAddress = getAPIAddress() else { callback(nil,CustomErrors.requestCreationError); return }
        
        // Check if the access token has already been setup
        guard let access_token = self.access_token else { callback(nil,CustomErrors.accessTokenNotProvidedError); return }
        
        jsonRequest(urlStr: "\(apiAddress)events/by-name/\(byName)?accesstoken=\(access_token)", httpMethod: "GET", parameters: nil, completion: { json, error in
            
            if let err = error {
                callback(nil, err)
            }else{
                // Unwrap JSON
                if let json = json {
                    
                    var events = [Event]()
                    
                    // Loop through event objects
                    for (_,object) in json {
                        if let event = Event(json: object){
                            events.append(event)
                        }
                    }
                    callback(events, nil)
                    
                // Return nil if JSON could not be unwrapped
                }else{
                    callback(nil, CustomErrors.jsonUnwrappingError)
                }
            }
        })
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                APPOINTMENT ENDPOINTS               /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    /// Method to get appointments for an specific event
    ///
    /// - Parameters:
    ///   - byEventID: The ID of the event from which we want to get the appointments
    ///   - callback: This callback method return either a list of appointments
    ///     or an error.
    func getAppointments(byEventID eventID: Int, callback: @escaping ([Appointment]?, CustomError?) -> Void){
        
        // Check if the address and port has been setup
        guard let apiAddress = getAPIAddress() else { callback(nil,CustomErrors.requestCreationError); return }
        
        // Check if the access token has already been setup
        guard let access_token = self.access_token else { callback(nil,CustomErrors.accessTokenNotProvidedError); return }
        
        jsonRequest(urlStr: "\(apiAddress)appointments/by-event-id/\(eventID)?accesstoken=\(access_token)", httpMethod: "GET", parameters: nil, completion: { json, error in
            
            if let err = error {
                callback(nil, err)
            }else{
                // Unwrap JSON
                if let json = json {
                    
                    var appointments = [Appointment]()
                    
                    // Loop through appointment objects
                    for (_,object) in json {
                        if let appointment = Appointment(json: object){
                            appointments.append(appointment)
                        }
                    }
                    callback(appointments, nil)
                    
                // Return nil if JSON could not be unwrapped
                }else{
                    callback(nil, CustomErrors.jsonUnwrappingError)
                }
            }
        })
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                PROFESSOR ENDPOINTS                 /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    
    /// Fetch a List of professors by name or part of the name.
    ///
    /// - Parameters:
    ///   - byName: search criteria
    ///   - callback: Callback Function that returns either a list of professors
    ///     or an error if something went wrong.
    func getProfessors(byName: String, callback: @escaping ([Professor]?, CustomError?) -> Void){
        
        // Check if the address and port has been setup
        guard let apiAddress = getAPIAddress() else { callback(nil,CustomErrors.requestCreationError); return }
        
        // Check if the access token has already been setup
        guard let access_token = self.access_token else { callback(nil,CustomErrors.accessTokenNotProvidedError); return }
        
        jsonRequest(urlStr: "\(apiAddress)professors/by-name/\(byName)?accesstoken=\(access_token)", httpMethod: "GET", parameters: nil, completion: { json, error in
            
            if let err = error {
                callback(nil, err)
            }else{
                // Unwrap JSON
                if let json = json {
                    var professors = [Professor]()
                    
                    // Loop through professor objects
                    for (_,object) in json {
                        if let professor = Professor(json: object){
                            professors.append(professor)
                        }
                    }
                    callback(professors, nil)
                    
                    // Return nil if JSON could not be unwrapped
                }else{
                    callback(nil, CustomErrors.jsonUnwrappingError)
                }
            }
        })
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////             API Network Helper Methods             /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    /// Method to concatenate the public address and the server port
    /// into one single server address string
    ///
    /// - Returns: The server URL Base String
    func getAPIAddress() ->  String? {
        
        if let addr = self.public_address, let port = self.port {
            return "http://\(addr):\(port)/api/"
        }else {
            return nil
        }
        
    }
    
    /// Use this method to make a http request where the response should be a json file
    ///
    /// - Parameters:
    ///   - urlStr: The url where to get the JSON from
    ///   - callback: The callback method that will be called after the http request has been made.
    func jsonRequest(urlStr: String, httpMethod: String, parameters: Parameters?, completion: @escaping (JSON?,CustomError?) -> Void){
        
        guard let url = URL(string: urlStr) else {
            // Return error for not being able to create url instance
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // Only add params if they are defined
        if let params = parameters {
            let pyload = try! JSONSerialization.data(withJSONObject: params);
            request.httpBody = pyload
        }
        
        Alamofire.request(request)
            .responseJSON { (dataResponse:DataResponse) in
                
                switch (dataResponse.result) {
                    
                case .success(let data):
                    
                    guard let httpResponse = dataResponse.response else {
                        
                        return
                    }
                    
                    if(httpResponse.statusCode == 200){
                        let json = JSON(data)
                        completion(json, nil)
                    }else{
                        self.handleJSONErrorResponse(statusCode: httpResponse.statusCode, completion: completion)
                    }
                    
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        completion(nil, CustomErrors.networkTimeoutError)
                    }else{
                        completion(nil, CustomErrors.networkRequestFailure.append(str: error.localizedDescription))
                    }
                    break
                }
        }
    }
    
    
    func handleJSONErrorResponse(statusCode: Int, completion: @escaping (JSON?,CustomError?) -> Void){
        
        if(statusCode == 404){
            completion(nil, CustomErrors.httpError404)
        }else if(statusCode == 403){
            completion(nil, CustomErrors.httpError403)
        }else{
            completion(nil, CustomErrors.networkRequestFailure)
        }
    }
    
    
}
