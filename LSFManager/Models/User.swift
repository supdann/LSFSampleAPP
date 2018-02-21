//
//  User.swift
//  LSFManager
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    var username: String
    var name: String
    var contact_info: String?
    var personal_email: String?
    var personal_address: String?
    
    init(username: String, name: String){
        self.username = username
        self.name = name
    }
}

class Student: User {
    
    var student_number: Int
    
    init?(json: JSON) {
        
        // Mandatory User Properties
        guard let username = json["username"].string, let name = json["name"].string else {
            return nil
        }
        
        // Mandatory Student Property
        guard let student_number = json["student_number"].int else {
            return nil
        }
        
        self.student_number = student_number
        super.init(username: username, name: name)
        
        
    }
    
}

class Professor: User {
    
    var pid: Int
    var consultation_time: String?
    var personalstatus: String?
    var status: String?
    var business_address: String?
    var business_email: String?
    var business_room: String?
    var web_link: String?
    var building: String?
    
    
    init?(json: JSON) {
        
        // Mandatory User Properties
        guard let username = json["username"].string, let name = json["name"].string else {
            return nil
        }
        
        // Mandatory Professor property
        guard let pid = json["pid"].int else {
            return nil
        }
        
        self.pid = pid
        super.init(username: username, name: name)
        
        
        // Optional properties
        if let consultation_time = json["consultation_time"].string {
            self.consultation_time = consultation_time
        }
        
        if let personalstatus = json["personalstatus"].string {
            self.personalstatus = personalstatus
        }
        
        if let status = json["status"].string {
            self.status = status
        }
        
        if let business_address = json["business_address"].string {
            self.business_address = business_address
        }
        
        if let business_email = json["business_email"].string {
           self.business_email = business_email
        }
        
        if let business_room = json["business_room"].string {
            self.business_room = business_room
        }
        
        if let web_link = json["web_link"].string {
            self.web_link = web_link
        }
        
        if let building = json["building"].string {
            self.building = building
        }
        
    }
    
}
