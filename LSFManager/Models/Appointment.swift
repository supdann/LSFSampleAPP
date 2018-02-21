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
    var event_id: Int // To which event does this appointment belong
    var appointment_type: AppointmentType
    var appointment_info: String
    var notes: String?
    var room:String?

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
    }
}
