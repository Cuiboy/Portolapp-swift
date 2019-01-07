//
//  my_numberToLabel.swift
//  PHS App
//
//  Created by Patrick Cui on 8/2/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import CoreData

func myClassArray() -> [String?] {
    var classes = [String]()
    let classFetchRequest: NSFetchRequest<MySchedule> = MySchedule.fetchRequest()
    do {
        var request = try PersistentService.context.fetch(classFetchRequest)
        if request.count > 0 {
            request.sort {$0.period < $1.period}
            for i in 0...7 {
                classes.append(request[i].name!)
            }
        } else {
            classes = []
        }
       
    } catch {
        
    }
    return classes
}

extension Int {
    func getPeriodLabel() -> String {
       
        switch self {
        case 1:
            if myClassArray().count == 0 {
                return "PERIOD 1"
            } else {
               
                return myClassArray()[0]?.uppercased() ?? "PERIOD 1"
            }
        case 2:
            if myClassArray().count == 0 {
                return "PERIOD 2"
            } else {
                 return myClassArray()[1]?.uppercased() ?? "PERIOD 2"
            }
        case 3:
            if myClassArray().count == 0 {
                return "PERIOD 3"
            } else {
                return myClassArray()[2]?.uppercased() ?? "PERIOD 3"

            }
        case 4:
            if myClassArray().count == 0 {
                return "PERIOD 4"
            } else {
                return myClassArray()[3]?.uppercased() ?? "PERIOD 4"

            }
        case 5:
            if myClassArray().count == 0 {
                return "PERIOD 5"
            } else {
                return myClassArray()[4]?.uppercased() ?? "PERIOD 5"

            }
        case 6:
            if myClassArray().count == 0 {
                return "PERIOD 6"
            } else {
                return myClassArray()[5]?.uppercased() ?? "PERIOD 6"

            }
        case 7:
            if myClassArray().count == 0 {
                return "PERIOD 7"
            } else {
                return myClassArray()[6]?.uppercased() ?? "PERIOD 7"

            }
        case 8:
            if myClassArray().count == 0 {
                return "PERIOD 8"
            } else {
                return myClassArray()[7]?.uppercased() ?? "PERIOD 8"

            }
        case 9:
            return "ADVISEMENT"
        case 10:
            return "OFFICE HOURS"
        case 11:
            return "PEP ASSEMBLY"
        case 12:
            return "LUNCH"
        case 13:
            return "BREAK"
        case 14:
            return "ASSEMBLY / PERIOD 4"
        case 15:
            return "PSAT"
        case 16:
            return "PE TESTING 9"
        case 17:
            return "ADVISEMENT / THEATE"
        case 18:
            return "THEATRE / ADVISEMENT"
        case 19:
            return "SESSION 1"
        case 20:
            return "SESSION 2"
        case 21:
            return "SESSION 3"
        case 22:
            return "SESSION 4"
        case 23:
            return "10-11 TESTING"
        case 24:
            return "JUNIORS TESTING"
        default: return ""
        }
    }
}

//1-8: PERIOD 1-8
//9: Advisement
//10: Office Hours
//11: Pep Assembly
//12: Lunch
//13: Break
//14: Assembly / PERIOD 4
//15: PSAT 9
//16: PE Testing 9
//17: Advisement / Theatre
//18: Theatre / Advisement
//19: SESSION 1
//20: SESSION 2
//21: SESSION 3
//22: SESSION 4
//23: 10-11 Testing
//24: 11 Testing
