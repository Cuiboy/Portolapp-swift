//
//  my_getStartEndLabel.swift
//  PHS App
//
//  Created by Patrick Cui on 8/1/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func my_getStartEndLabel(type: Int) -> [Bool]? {
    switch type {
    case 0:
        return defaultDaysStartEndLabel()
    case 1, 2:
        //pep assembly odd
        return [false, true, false, false, false, true, false, false, true, false, false, true, false]
    case 3, 4, 14:
        //extended lunch odd and hour of code
        return [false, true, false, false, true, false, false, true, false, false, true, false]

    case 5, 6:
        //finals type 1
        return [false, true, false, true, false]

    case 7:
        //finals two periods
        return [false, true, false]
    case 8:
        //minimum 1-8
        return [false, true, false, true, false, true, false, false, true, false, true, false, true, false, true, false]
    case 9, 10:
        //conferences
        return [false, true, false, false, true, false, true, false]
    case 11, 12:
        //PSAT 9 and PE testing
        return [false, false, true, false, true, false, false, true, false, true, false]

    case 13:
        //first 2 days of school
        return [false, true, false, true, false, true, false, false, true, false, true, false, false, true, false, true, false, true, false]

    case 15:
        //Passion Day
        return [false, true, false, false, true, false, true, false]
    case 16:
        //Pre Testing
        return [false, true, false, false, true, false, true, false, false, true, false, true, false]
    case 17:
        //Testing
        return [false, false, true, false, false, true, false, true, false]
    case 18, 19:
        //CAASPP
        return [false, false, true, false, true, false, true, false, false, false, true, false]
    case 20:
        //NO SCHOOL
        return nil
    case 21:
        //fine arts assembly
        return [false, false, true, false, false, true, false, false, true, false]
    case 22:
        //monday schedule
        return [false, true, false, true, false, false, true, false, true, false, false, true, false, true, false, true, false]
    case 23, 26, 28:
        //tuesday and friday schedule
        return [false, true, false, false, true, false, false, true, false, false, true, false]
    case 24, 25, 27:
        //wednesday and thursday schedule
        return [false, false, false, true, false, false, true, false, false, true, false]
    case 29:
        //super late start
        return [false, true, false, false, true, false, true, false]
   
    default:
        return defaultDaysStartEndLabel()
    }
}

func defaultDaysStartEndLabel() -> [Bool]? {
    switch Calendar.current.component(.weekday, from: Date()) {
    case 1, 7:
        return nil
    case 2:
        return [false, true, false, true, false, false, true, false, true, false, false, true, false, true, false, true, false]
    case 3, 6:
        return [false, true, false, false, true, false, false, true, false, false, true, false]
    case 4, 5:
        return [false, false, false, true, false, false, true, false, false, true, false]

    default: return nil
    }
}
