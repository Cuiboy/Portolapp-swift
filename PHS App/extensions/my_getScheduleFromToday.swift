//
//  my_getSchedule.swift
//  PHS App
//
//  Created by Patrick Cui on 7/31/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
func my_getSchedule(type: Int, date: Date?) -> [Date]? {
    switch type {
    case 0:
        return defaultPeriods(date: date)
    case 1, 2:
        //pep assembly
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 20), DateFromTime(hour: 9, minute: 26), DateFromTime(hour: 9, minute: 41), DateFromTime(hour: 9, minute: 41), DateFromTime(hour: 10, minute: 17), DateFromTime(hour: 10, minute: 17), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 33),DateFromTime(hour: 11, minute: 53), DateFromTime(hour: 11, minute: 53), DateFromTime(hour: 12, minute: 28), DateFromTime(hour: 12, minute: 34), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 14, minute: 4), DateFromTime(hour: 14, minute: 10), DateFromTime(hour: 15, minute: 30)]
        
    case 3, 4:
        //extended lunch
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 19), DateFromTime(hour: 9, minute: 25), DateFromTime(hour: 10, minute: 4),  DateFromTime(hour: 10, minute: 14), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 11, minute: 39), DateFromTime(hour: 12, minute: 30), DateFromTime(hour: 12, minute: 36), DateFromTime(hour: 13, minute: 55), DateFromTime(hour: 14, minute: 5), DateFromTime(hour: 14, minute: 11), DateFromTime(hour: 15, minute: 30)]

    case 5, 6:
        //finals 3 periods
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 23), DateFromTime(hour: 9, minute: 33), DateFromTime(hour: 10, minute: 56), DateFromTime(hour: 11, minute: 6), DateFromTime(hour: 12, minute: 29)]

    case 7:
        //finals two periods
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 25), DateFromTime(hour: 9, minute: 35), DateFromTime(hour: 11, minute: 0)]
        
    case 8:
        //minimum 1-8
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 8, minute: 27), DateFromTime(hour: 8, minute: 33), DateFromTime(hour: 9, minute: 0), DateFromTime(hour: 9, minute: 6), DateFromTime(hour: 9, minute: 33), DateFromTime(hour: 9, minute: 39),DateFromTime(hour: 10, minute: 6), DateFromTime(hour: 10, minute: 6), DateFromTime(hour: 10, minute: 16), DateFromTime(hour: 10, minute: 22), DateFromTime(hour: 10, minute: 49), DateFromTime(hour: 10, minute: 55), DateFromTime(hour: 11, minute: 22), DateFromTime(hour: 11, minute: 28), DateFromTime(hour: 11, minute: 55), DateFromTime(hour: 12, minute: 1), DateFromTime(hour: 12, minute: 28)]
        
    case 9, 10:
        //conferences
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 0), DateFromTime(hour: 9, minute: 6), DateFromTime(hour: 10, minute: 6), DateFromTime(hour: 10, minute: 6), DateFromTime(hour: 10, minute: 16),  DateFromTime(hour: 10, minute: 22), DateFromTime(hour: 11, minute: 22), DateFromTime(hour: 11, minute: 28), DateFromTime(hour: 12, minute: 28)]

    case 11:
        //PSAT 9
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 10, minute: 54), DateFromTime(hour: 10, minute: 54), DateFromTime(hour: 11, minute: 15), DateFromTime(hour: 11, minute: 21), DateFromTime(hour: 12, minute: 10), DateFromTime(hour: 12, minute: 16), DateFromTime(hour: 13, minute: 5),DateFromTime(hour: 13, minute: 5), DateFromTime(hour: 13, minute: 40), DateFromTime(hour: 13, minute: 46), DateFromTime(hour: 14, minute: 35), DateFromTime(hour: 14, minute: 41), DateFromTime(hour: 15, minute: 30)]
    case 12:
        //PE testing
        return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 10, minute: 54),  DateFromTime(hour: 10, minute: 54), DateFromTime(hour: 11, minute: 15), DateFromTime(hour: 11, minute: 21), DateFromTime(hour: 12, minute: 10), DateFromTime(hour: 12, minute: 16), DateFromTime(hour: 13, minute: 5), DateFromTime(hour: 13, minute: 5), DateFromTime(hour: 13, minute: 40), DateFromTime(hour: 13, minute: 46), DateFromTime(hour: 14, minute: 35), DateFromTime(hour: 14, minute: 41), DateFromTime(hour: 15, minute: 30)]
    case 13:
        //first 2 days of school
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 8, minute: 25), DateFromTime(hour: 8, minute: 31), DateFromTime(hour: 9, minute: 12), DateFromTime(hour: 9, minute: 18), DateFromTime(hour: 9, minute: 59), DateFromTime(hour: 10, minute: 5), DateFromTime(hour: 10, minute: 46), DateFromTime(hour: 10, minute: 46), DateFromTime(hour: 10, minute: 59), DateFromTime(hour: 11, minute: 5), DateFromTime(hour: 11, minute: 46), DateFromTime(hour: 11, minute: 52), DateFromTime(hour: 12, minute: 33),DateFromTime(hour: 12, minute: 33), DateFromTime(hour: 13, minute: 9), DateFromTime(hour: 13, minute: 15), DateFromTime(hour: 13, minute: 56), DateFromTime(hour: 14, minute: 2), DateFromTime(hour: 14, minute: 43), DateFromTime(hour: 14, minute: 39), DateFromTime(hour: 15, minute: 30)]
    case 14:
        //Hour of Code
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 20), DateFromTime(hour: 9, minute: 26), DateFromTime(hour: 10, minute: 17),  DateFromTime(hour: 10, minute: 17), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 33), DateFromTime(hour: 11, minute: 53), DateFromTime(hour: 11, minute: 53), DateFromTime(hour: 12, minute: 28), DateFromTime(hour: 12, minute: 34), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 14, minute: 4), DateFromTime(hour: 14, minute: 10), DateFromTime(hour: 15, minute: 30)]
    case 15:
        //Passion Day
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 8, minute: 40), DateFromTime(hour: 9, minute: 40),  DateFromTime(hour: 9, minute: 40), DateFromTime(hour: 9, minute: 55), DateFromTime(hour: 10, minute: 0), DateFromTime(hour: 11, minute: 0),DateFromTime(hour: 11, minute: 10), DateFromTime(hour: 12, minute: 10)]
    case 16:
        //Pre Testing
        return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 9, minute: 34), DateFromTime(hour: 9, minute: 40), DateFromTime(hour: 10, minute: 5),DateFromTime(hour: 10, minute: 5), DateFromTime(hour: 10, minute: 15), DateFromTime(hour: 10, minute: 21),  DateFromTime(hour: 11, minute: 25), DateFromTime(hour: 11, minute: 31), DateFromTime(hour: 12, minute: 35), DateFromTime(hour: 12, minute: 35), DateFromTime(hour: 13, minute: 10), DateFromTime(hour: 13, minute: 16), DateFromTime(hour: 14, minute: 20), DateFromTime(hour: 14, minute: 26), DateFromTime(hour: 15, minute: 30)]
    case 17:
        //Testing
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 10, minute: 54),DateFromTime(hour: 10, minute: 54), DateFromTime(hour: 11, minute: 25), DateFromTime(hour: 11, minute: 31), DateFromTime(hour: 12, minute: 35), DateFromTime(hour: 12, minute: 35), DateFromTime(hour: 13, minute: 10), DateFromTime(hour: 13, minute: 16),DateFromTime(hour: 14, minute: 20), DateFromTime(hour: 14, minute: 26), DateFromTime(hour: 15, minute: 30)]
        
    case 18, 19:
        //CAASPP
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 10, minute: 50), DateFromTime(hour: 11, minute: 0),DateFromTime(hour: 11, minute: 6), DateFromTime(hour: 11, minute: 23), DateFromTime(hour: 11, minute: 29), DateFromTime(hour: 12, minute: 16), DateFromTime(hour: 12, minute: 22),DateFromTime(hour: 13, minute: 9), DateFromTime(hour: 13, minute: 44), DateFromTime(hour: 13, minute: 50), DateFromTime(hour: 14, minute: 37), DateFromTime(hour: 14, minute: 43), DateFromTime(hour: 15, minute: 30)]

    case 20:
        //NO SCHOOL
        return nil
        
    case 21:
        //fine arts assembly
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 20), DateFromTime(hour: 9, minute: 20), DateFromTime(hour: 9, minute: 30), DateFromTime(hour: 9, minute: 36), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 33), DateFromTime(hour: 11, minute: 53),DateFromTime(hour: 11, minute: 53), DateFromTime(hour: 12, minute: 28), DateFromTime(hour: 12, minute: 34), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 14, minute: 4), DateFromTime(hour: 14, minute: 10), DateFromTime(hour: 15, minute: 30)]

    case 22:
        //monday schedule
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 8, minute: 45), DateFromTime(hour: 8, minute: 51), DateFromTime(hour: 9, minute: 36), DateFromTime(hour: 9, minute: 42), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 41), DateFromTime(hour: 10, minute: 47), DateFromTime(hour: 11, minute: 32), DateFromTime(hour: 11, minute: 38), DateFromTime(hour: 12, minute: 23), DateFromTime(hour: 12, minute: 23),DateFromTime(hour: 12, minute: 57), DateFromTime(hour: 13, minute: 3), DateFromTime(hour: 13, minute: 48), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 14, minute: 39), DateFromTime(hour: 14, minute: 45), DateFromTime(hour: 15, minute: 30)]
    case 23, 26, 28:
       
        return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 9, minute: 49), DateFromTime(hour: 9, minute: 55), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 10, minute: 30), DateFromTime(hour: 10, minute: 36), DateFromTime(hour: 11, minute: 55), DateFromTime(hour: 11, minute: 55), DateFromTime(hour: 12, minute: 30), DateFromTime(hour: 12, minute: 36), DateFromTime(hour: 13, minute: 55), DateFromTime(hour: 13, minute: 55), DateFromTime(hour: 14, minute: 5), DateFromTime(hour: 14, minute: 11), DateFromTime(hour: 15, minute: 30)]
    case 24, 25, 27:

        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 24), DateFromTime(hour: 9, minute: 24), DateFromTime(hour: 10, minute: 3),DateFromTime(hour: 10, minute: 3), DateFromTime(hour: 10, minute: 14), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 11, minute: 44), DateFromTime(hour: 11, minute: 44),  DateFromTime(hour: 12, minute: 19), DateFromTime(hour: 12, minute: 25), DateFromTime(hour: 13, minute: 49), DateFromTime(hour: 13, minute: 49), DateFromTime(hour: 14, minute: 0), DateFromTime(hour: 14, minute: 6), DateFromTime(hour: 15, minute: 30)]

   
    default:
        return defaultPeriods(date: nil)
    }
}

func defaultPeriods(date: Date?) -> [Date]? {
    var day = Int()
    if date == nil {
        day = Calendar.current.component(.weekday, from: Date())
    } else {
        day = Calendar.current.component(.weekday, from: date!)
    }
    switch day {
    case 1, 7:
        return nil
    case 2:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 8, minute: 45), DateFromTime(hour: 8, minute: 51), DateFromTime(hour: 9, minute: 36), DateFromTime(hour: 9, minute: 42), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 27), DateFromTime(hour: 10, minute: 41), DateFromTime(hour: 10, minute: 47), DateFromTime(hour: 11, minute: 32), DateFromTime(hour: 11, minute: 38), DateFromTime(hour: 12, minute: 23), DateFromTime(hour: 12, minute: 23),DateFromTime(hour: 12, minute: 57), DateFromTime(hour: 13, minute: 3), DateFromTime(hour: 13, minute: 48), DateFromTime(hour: 13, minute: 54), DateFromTime(hour: 14, minute: 39), DateFromTime(hour: 14, minute: 45), DateFromTime(hour: 15, minute: 30)]
        
    case 3, 6:
                 return [DateFromTime(hour: 8, minute: 30), DateFromTime(hour: 9, minute: 49), DateFromTime(hour: 9, minute: 55), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 10, minute: 30), DateFromTime(hour: 10, minute: 36), DateFromTime(hour: 11, minute: 55), DateFromTime(hour: 11, minute: 55), DateFromTime(hour: 12, minute: 30), DateFromTime(hour: 12, minute: 36), DateFromTime(hour: 13, minute: 55), DateFromTime(hour: 13, minute: 55), DateFromTime(hour: 14, minute: 5), DateFromTime(hour: 14, minute: 11), DateFromTime(hour: 15, minute: 30)]
    case 4, 5:
        return [DateFromTime(hour: 8, minute: 0), DateFromTime(hour: 9, minute: 24), DateFromTime(hour: 9, minute: 24), DateFromTime(hour: 10, minute: 3),DateFromTime(hour: 10, minute: 3), DateFromTime(hour: 10, minute: 14), DateFromTime(hour: 10, minute: 20), DateFromTime(hour: 11, minute: 44), DateFromTime(hour: 11, minute: 44),  DateFromTime(hour: 12, minute: 19), DateFromTime(hour: 12, minute: 25), DateFromTime(hour: 13, minute: 49), DateFromTime(hour: 13, minute: 49), DateFromTime(hour: 14, minute: 0), DateFromTime(hour: 14, minute: 6), DateFromTime(hour: 15, minute: 30)]

    default: return nil
        
    }
}


