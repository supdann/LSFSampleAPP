//
//  Event.swift
//  LSFManager
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import Foundation
import SwiftyJSON

enum EventType: Int {
    
    case Lecture = 0
    case Exam = 1
    case Other = 2
    
}

// An Event is a Lecture as well.
class Event {
    
    var title: String
    var language: String
    var event_id: Int
    var information: String
    var course: String // Studiengang in German
    
    var appointments = [Appointment]()
    
    init?(json: JSON){
        
        guard let title = json["title"].string,
            let language = json["language"].string,
            let event_id = json["event_id"].int,
            let information = json["information"].string,
            let course = json["course"].string else {
                return nil
        }
        
        self.title = title
        self.language = language
        self.event_id = event_id
        self.information = information
        self.course = course
        
    }
    
}
