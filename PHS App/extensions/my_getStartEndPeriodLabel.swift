//
//  my_getStartEndPeriodLabel.swift
//  PHS App
//
//  Created by Patrick Cui on 8/1/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func my_getStartEndPeriodLabel(type: Int) -> [Int]? {
    
    switch type {
    case 0:
        return defaultDaysStartEndPeriodLabel()
    case 1:
        //pep assembly odd
        return [1, 9, 9, 11, 13, 3, 3, 12, 5, 5, 13, 7, 7]
    case 2:
        //pep assembly even
        return [2, 9, 9, 11, 13, 4, 4, 12, 6, 6, 13, 8, 8]
    case 3:
        //extended lunch odd
        return [1, 9, 9, 13, 3, 3, 12, 5, 5, 13, 7, 7]
    case 4, 14:
        //extended lunch even and hour of code
        return [2, 9, 9, 13, 4, 4, 12, 6, 6, 13, 8, 8]

    case 5:
        //finals type 1
        return [1, 3, 3, 7, 7]
    case 6:
        //finals type 2
        return [2, 4, 4, 8, 8]
    case 7:
        //finals two periods
        return [5, 6, 6]
    case 8:
        //minimum 1-8
        return [1, 2, 2, 3, 3, 4, 4, 13, 5, 5, 6, 6, 7, 7, 8, 8]
    case 9:
        //conferences odd
        return [1, 3, 3, 13, 5, 5, 7, 7]
    case 10:
        //conferences even
        return [2, 4, 4, 13, 6, 6, 8, 8]
    case 11:
        //PSAT 9
        return [15, 10, 2, 2, 4, 4, 12, 6, 6, 8, 8]
    case 12:
        //PE testing
        return [16, 10, 1, 1, 3, 3, 12, 5, 5, 7, 7]

    case 13:
        //first 2 days of school
        return [9, 1, 1, 2, 2, 3, 3, 13, 4, 4, 5, 5, 12, 6, 6, 7, 7, 8, 8]
    
    case 15:
        //Passion Day
        return [17, 18, 18, 13, 19, 19, 20, 20, 12, 21, 21, 22, 22, 13, 17, 17]
    case 16:
        //Pre Testing
        return [1, 9, 9, 13, 2, 2, 3, 3, 12, 5, 5, 7, 7]
    case 17:
        //Testing
        return [23, 10, 4, 4, 12, 6, 6, 8, 8]
    case 18:
        //CAASPP odd
        return [24, 10, 1, 1, 3, 3, 12, 5, 5, 7, 7]
    case 19:
        //CAASPP even
        return [24, 10, 2, 2, 4, 4, 12, 6, 6, 8, 8]
    case 20:
        //NO SCHOOL
        return nil
    case 21:
        //fine arts assembly
        return [2, 13, 14, 14, 12, 6, 6, 13, 8, 8]
    case 22:
        //monday schedule
        return [1, 2, 2, 3, 3, 13, 4, 4, 5, 5, 12, 6, 6, 7, 7, 8, 8]
    case 23:
        //tuesday schedule
        return [1, 9, 9, 13, 3, 3, 12, 5, 5, 13, 7, 7]
    case 24:
        //wednesday schedule
        return [2, 10, 13, 4, 4, 12, 6, 6, 13, 8, 8]
    case 25:
        //thursday schedule
        return [1, 10, 13, 3, 3, 12, 5, 5, 13, 7, 7]
    case 26:
        //friday schedule
        return [2, 9, 9, 13, 4, 4, 12, 6, 6, 13, 8, 8]
    default:
        return defaultDaysStartEndPeriodLabel()
    }
}

func defaultDaysStartEndPeriodLabel() -> [Int]? {
    switch Calendar.current.component(.weekday, from: Date()) {
    case 1, 7:
        return nil
    case 2:
        return [1, 2, 2, 3, 3, 13, 4, 4, 5, 5, 12, 6, 6, 7, 7, 8, 8]
    case 3:
        return [1, 9, 9, 13, 3, 3, 12, 5, 5, 13, 7, 7]
    case 4:
        return [2, 10, 13, 4, 4, 12, 6, 6, 13, 8, 8]
    case 5:
        return [1, 10, 13, 3, 3, 12, 5, 5, 13, 7, 7]
    case 6:
        return [2, 9, 9, 13, 4, 4, 12, 6, 6, 13, 8, 8]
    default: return nil
    }
}
