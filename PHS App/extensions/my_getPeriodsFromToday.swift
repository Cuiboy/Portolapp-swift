//
//  my_getPeriodsFromToday.swift
//  PHS App
//
//  Created by Patrick Cui on 7/31/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func my_getPeriodsFromToday(type: Int) -> [String] {
    switch type {
    case 0:
        return defaultDays()
    case 1:
        //pep assembly odd
        return ["1", "A", "PA", "3", "5", "7"]
    case 2:
        //pep assembly even
        return ["2", "A", "PA", "4", "6", "8"]
    case 3:
        //extended lunch odd
        return ["1", "OH", "3", "L", "5", "7"]
    case 4:
        //extended lunch even
        return ["2", "A", "4", "L", "6", "8"]
    case 5:
        //finals type 1
        return ["1", "3", "7"]
    case 6:
        //finals type 2
        return ["2", "4", "8"]
    case 7:
        //finals two periods
        return ["5", "6"]
    case 8:
        //minimum 1-8
        return ["1", "2", "3", "4", "5", "6", "7", "8"]
    case 9:
        //minimum odd
        return ["1", "3", "5", "7"]
    case 10:
        //minimum even
        return ["2", "4", "6", "8"]
    case 11:
        //PSAT 9
        return ["PSAT 9", "OH", "2", "4", "6", "8"]
    case 12:
        //PE testing
        return ["PE 9", "OH", "1", "3", "5", "7"]
    case 13:
        //first 2 days of school
        return ["A", "1", "2", "3", "4", "5", "6", "7", "8"]
    case 14:
        //Hour of Code
        return ["2", "A", "4", "6", "8"]
    case 15:
        //Passion Day
        return ["A", "S1", "S2", "S3"]
    case 16:
        //Pre Testing
        return ["1", "A", "2", "3", "5", "7"]
    case 17:
        //Testing2018/
        return ["TEST", "OH", "4", "6", "8"]
    case 18:
        //CAASPP ODD
        return ["TEST 11", "OH", "1", "3", "5", "7"]
    case 19:
        //CAASPP EVEN
         return ["TEST 11", "OH", "2", "4", "6", "8"]
    case 20:
        //NO SCHOOL
        return ["NO SCHOOL TODAY"]
    case 21:
        //fine arts assembly
        return ["2", "A/4", "A/4", "6", "8"]
    case 22:
        //monday schedule
         return ["1", "2", "3", "4", "5", "6", "7", "8"]
    case 23:
        //tuesday schedule
          return ["1", "A", "3", "5", "7"]
    case 24:
        //wednesday schedule
         return ["2", "OH", "4", "6", "8"]
    case 25:
        //thursday schedule
          return ["1", "OH", "3", "5", "7"]
    case 26:
        //friday schedule
         return ["2", "A", "4", "6", "8"]
    case 27:
        //thursday advisement
        return ["1", "A", "3", "5", "7"]
    case 28:
        //friday OH
        return ["2", "OH", "4", "6", "8"]
        
    default:
        return defaultDays()
    }
}

func defaultDays() -> [String] {
    switch Calendar.current.component(.weekday, from: Date()) {
    case 1, 7:
        return ["NO SCHOOL TODAY"]
    case 2:
        return ["1", "2", "3", "B", "4", "5", "L", "6", "7", "8"]
    case 3:
        return ["1", "A", "3", "5", "7"]
    case 4:
        return ["2", "OH", "4", "6", "8"]
    case 5:
        return ["1", "OH", "3", "5", "7"]
    case 6:
        return ["2", "A", "4", "6", "8"]
    default: return ["Error"]
    }
}


