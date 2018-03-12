//
//  Appointment.swift
//  LSFManager
//
//  Created by Daniel Montano on 25.01.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AppointmentType: Int {
    
    case Lecture = 0
    case Exam = 1
    case Undefined = 2
    
}

class Appointment {
    
    var pid: Int // ID of the Professor that takes care of this appointment
    var event_id: Int // This id the id of the event to which this appointment belongs
    var appointment_type: AppointmentType
    var appointment_info: String
    var notes: String?
    var room:String?
    var start: Int?
    var end: Int?
    var day: String?
    var frequency: Int?
    var title: String?
    
    init?(json: JSON){
        
        guard let pid = json["pid"].int,
            let event_id = json["event_id"].int,
            let type = json["appointment_type"].int,
            let info = json["appointment_info"].string else {
            return nil
        }
        
        self.pid = pid
        self.event_id = event_id
        
        if(type == 0){
            self.appointment_type = .Lecture
        }else if(type == 1){
            self.appointment_type = .Exam
        }else {
            self.appointment_type = .Undefined
        }
        
        self.appointment_info = info
        
        if let notes = json["notes"].string {
            self.notes = notes
        }
        
        if let room = json["room"].string {
            self.room = room
        }
        
        if let day = json["day"].string {
            self.day = day
        }
        
        if let start = json["start"].int {
            self.start = start
        }
        
        if let end = json["end"].int {
            self.end = end
        }
        
        if let frequency = json["frequency"].int {
            self.frequency = frequency
        }else{
            self.frequency = 0
        }
        
        if let title = json["title"].string {
            self.title = title
        }
    }
    
    func getTimeText(time: Int?) -> String {
        
        guard let time = time else {
            return "undefined"
        }
        
        var timeAsString = String(describing: time)
        
        if(timeAsString.count == 3){
            timeAsString = "0\(timeAsString)"
        }
        
        let splitIndex = timeAsString.index(timeAsString.startIndex, offsetBy: 2)
        
        let hours = String(timeAsString[..<splitIndex])
        
        let minutes = String(timeAsString[splitIndex...])
        
        return "\(hours):\(minutes)"
        
    }
    
    func getEndTimeText() -> String {
        return getTimeText(time: self.end)
    }
    
    func getStartTimeText() -> String{
        return getTimeText(time: self.start)
    }
}
