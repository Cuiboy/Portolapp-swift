//
//  my_getWeekdayString.swift
//  PHS App
//
//  Created by Patrick Cui on 7/29/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func getWeekdayString(date: Date, isUpper: Bool) -> String {
    let weekday = Calendar.current.component(.weekday, from: date)
    if isUpper {
        switch weekday {
        case 1:
            return "SUNDAY"
        case 2:
            return "MONDAY"
        case 3:
            return "TUESDAY"
        case 4:
            return "WEDNESDAY"
        case 5:
            return "THURSDAY"
        case 6:
            return "FRIDAY"
        case 7:
            return "SATURDAY"
        default:
            return "COMING UP"
        }
    } else {
        switch weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Satueday"
        default:
            return "Coming Up"
        }
    }
   
    
    
}
