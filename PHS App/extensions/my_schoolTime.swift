//
//  my_schoolTime.swift
//  PHS App
//
//  Created by Patrick Cui on 10/22/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension Date {
    func timeOfSchoolDay() -> relativeTime? {
        if self.isSchoolDay() {
            let type = getDayType(date: self)
            let startTime = my_getSchedule(type: type, date: self)!.first!
            let endTime = my_getSchedule(type: type, date: self)!.last!
            if self.localTime() < startTime {
               return .before
            } else if self.localTime() > endTime {
                return .after
            } else {
                return .during
            }
        } else {
            return nil
            
        }
    }
}
