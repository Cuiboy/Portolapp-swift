//
//  my_minutesFromSchoolStart.swift
//  PHS App
//
//  Created by Patrick Cui on 8/4/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension Date {
    func minFromSchoolStart() -> Int {
        if today == 20 || !self.isSchoolDay() {
            return 1
        } else {
            let now = self
            
            let todaySchedule = my_getSchedule(type: today, date: self)
            let start = todaySchedule!.first!
            let interval = Calendar.current.dateComponents([.minute], from: start, to: now).minute
            return interval!
        }
        
        
    }
}
