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
       
        if self.isSchoolDay() {
            let type = getDayType(date: self)
            let schedule = my_getSchedule(type: type, date: nil)!
            let start = schedule.first!.UTC()
            let end = schedule.last!.UTC()
            if self < start {
                return .before
            } else if self >= end {
                return .after
            } else {
                return .during
            }
            
        } else {
            return nil
        }
    }
}
