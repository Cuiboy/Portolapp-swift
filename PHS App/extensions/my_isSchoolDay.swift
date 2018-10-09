//
//  my_isSchoolDay.swift
//  PHS App
//
//  Created by Patrick Cui on 8/4/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension Date {
    func isSchoolDay() -> Bool {
        print("TODAY IS ACTUALLY \(self)")
        let type = getDayType(date: self)
        print("TODAY TYPE IS \(type)")
        if type == 20 {
            
            return false
        } else {
            if Calendar.current.component(.weekday, from: self) == 7 ||  Calendar.current.component(.weekday, from: self) == 1 {
                return false
            } else {
                
                return true
            }
        }
    }
}
