//
//  my_getStartEndTimeFromToday.swift
//  PHS App
//
//  Created by Patrick Cui on 7/31/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation


func my_getStartEndTimeFromToday(type: Int, dayType: dayType, date: Date?) -> [Date] {
    switch type {
    case 0:
        return defaultDaysStartEnd(dayType: dayType, date: date)
        
    case 1, 2, 3, 4, 11, 13, 14, 17, 18, 19, 21:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 15, minute: 30)]
    case 5, 6:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 12, minute: 29)]
    case 7:
         return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 11, minute: 00)]
    case 8, 9, 10:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 12, minute: 28)]
    case 15:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 14, minute: 31)]
    case 12, 16:
        return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 15, minute: 30)]
    case 20:
        return [Date()]
    case 22, 24, 25:
        //8 am start regular
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 15, minute: 30) ]
    case 23, 26:
        //8:30 am start regular
        return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 15, minute: 30) ]
  
    
    default:
        return defaultDaysStartEnd(dayType: dayType, date: date)
    }
}



func defaultDaysStartEnd(dayType: dayType, date: Date?) -> [Date] {
    var weekday = Int()
    switch dayType {
    case .today:
        weekday = Calendar.current.component(.weekday, from: Date())
    case .tomorrow:
         weekday = Calendar.current.component(.weekday, from: Date()) + 1
    case .nextMonday:
        weekday = 0
    case .custom:
        weekday = Calendar.current.component(.weekday, from: date!)
        
    }
    switch weekday {

    case 1, 2, 7, 4, 5:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 15, minute: 30)]
    case 3, 6:
       return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 15, minute: 30)]

    default:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 15, minute: 30)]
    }
}



func DateFromTime(hour: Int, minute: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.timeZone = Calendar.current.timeZone
    dateComponents.year = Calendar.current.component(.year, from: Date().noon)
    dateComponents.month = Calendar.current.component(.month, from: Date().noon)
    dateComponents.day = Calendar.current.component(.day, from: Date().noon)
    
   
    
    dateComponents.hour = hour + UTCDifference()
  
    dateComponents.minute = minute
    
   
    
    let userCalendar = Calendar.current
    
    if let milDate = userCalendar.date(from: dateComponents)?.timeIntervalSince1970 {
        return Date(timeIntervalSince1970: milDate)

    }
    
    
    
   return Date()
}

