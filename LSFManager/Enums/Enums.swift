//
//  Enums.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation

enum SearchType {
    case Professor
    case Event
    case None
}

// LPA ist just an abbreviation for Lectures Professors and Appointments
enum LPAListType {
    case Event
    case Professor
    case Appointment
    case None
}

// This is for views that can have mutiple types of button on the top left side
enum TopLeftButtonType {
    case Back
    case Menu
}

