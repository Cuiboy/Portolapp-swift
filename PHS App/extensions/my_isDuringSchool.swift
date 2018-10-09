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
        let currentTime = self.localTime()
        
            if currentTime.isSchoolDay() {
                
                let type = getDayType(date: currentTime)
                let schedule = my_getSchedule(type: type, date: currentTime)!
                let start = schedule.first!
                let end = schedule.last!
                print(currentTime, start, end)
                if currentTime < start {
                   
                    return .before
                } else if currentTime >= end {
                    
                    return .after
                } else {
                     
                    return .during
                }
                
            } else {
               print(currentTime)
                return nil
            }
        
     
    }
}
