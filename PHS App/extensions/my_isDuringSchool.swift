//
//  my_isDuringSchool.swift
//  PHS App
//
//  Created by Patrick Cui on 8/4/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

enum relativeTime {
    case before
    case during
    case after
}

extension Date {
    func getRelativeTime() -> relativeTime? {
        if let currentTime = Calendar.current.date(byAdding: .hour, value: UTCDifference(), to: self) {
            if currentTime.isSchoolDay() {
                let type = getDayType(date: currentTime)
                let schedule = my_getSchedule(type: type, date: currentTime)!
                let start = schedule.first!
                let end = schedule.last!
            
                if currentTime < start {
                   
                    return .before
                } else if currentTime >= end {
                    
                    return .after
                } else {
                     
                    return .during
                }
                
            } else {
                return nil
            }
        } else {
            return nil
        }
     
    }
}
