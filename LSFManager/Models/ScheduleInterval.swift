//
//  ScheduleInterval.swift
//  LSFManager
//
//  Created by Daniel Montano on 13.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import SwiftyJSON


class ScheduleInterval{
    
    let start: Int
    let length: Int
    let color: UIColor
    let text: String
    
    init?(json: JSON){
        
        guard let start = json["start"].int,
            let length = json["length"].int,
            let text = json["text"].string,
            let type = json["type"].int else {
                return nil
        }
        
        switch type {
        case 1:
            color = Constants.lsfBlue
        case 2:
            color = Constants.lsfYellow
        case 3:
            color = Constants.lsfLightBlue
        case 4:
            color = Constants.lsfGreen
        case 5:
            color = Constants.lsfLightGreen
        default:
            color = UIColor.white
        }
        
        self.start = start
        self.length = length
        self.text = text
        
    }
    
}

class ScheduleIntervalLayer {
    
    let position: Int
    var intervals1 = [ScheduleInterval]()
    var intervals2 = [ScheduleInterval]()
    var intervals3 = [ScheduleInterval]()
    var grayDays = [Int]()
    var orangeDays =  [Int]()
    var days = [Int]()
    
    init?(json: JSON){
        
        guard let position = json["position"].int,
            let intervals1 = json["intervals1"].array,
            let intervals2 = json["intervals2"].array,
            let intervals3 = json["intervals3"].array,
            let days = json["days"].arrayObject as? [Int],
            let grayDays = json["grayDays"].arrayObject as? [Int],
            let orangeDays = json["orangeDays"].arrayObject as? [Int] else {
                return nil
        }
        
        self.position = position
        
        
        for json in intervals1 {
            if let interval = ScheduleInterval(json: json){
                self.intervals1.append(interval)
            }
        }
        
        for json in intervals2 {
            if let interval = ScheduleInterval(json: json){
                self.intervals2.append(interval)
            }
        }
        
        for json in intervals3 {
            if let interval = ScheduleInterval(json: json){
                self.intervals3.append(interval)
            }
        }
        
        for day in days {
            self.days.append(day)
        }
        
        for grayDay in grayDays {
            self.grayDays.append(grayDay)
        }
        
        for orangeDay in orangeDays {
            self.orangeDays.append(orangeDay)
        }
        
    }
}
