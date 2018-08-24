//
//  my_nextMonday.swift
//  PHS App
//
//  Created by Patrick Cui on 8/2/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension Date {
    func nextMonday() -> Date {
        var dayToAdd = Int()
        switch Calendar.current.component(.weekday, from: self) {
            case 1:
                dayToAdd = 1
            case 2:
                dayToAdd = 7
            case 3:
            dayToAdd = 6

            case 4:
            dayToAdd = 5

            case 5:
            dayToAdd = 4

            case 6:
            dayToAdd = 3

            case 7:
            dayToAdd = 2
        default:
            dayToAdd = 9 - Calendar.current.component(.weekday, from: self)

        }
        
       
        
        let date = Calendar.current.date(byAdding: .day, value: dayToAdd, to: self)
        return date!
    }
}
