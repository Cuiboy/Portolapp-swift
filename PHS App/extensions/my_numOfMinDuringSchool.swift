//
//  my_numOfMinDuringSchool.swift
//  PHS App
//
//  Created by Patrick Cui on 8/4/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func numOfMinAtSchool(type: Int) -> Int? {
    let schedule = my_getSchedule(type: type, date: nil) 
    if type == 20 {
        return nil
    } else {
        if Calendar.current.component(.weekday, from: Date()) == 1 || Calendar.current.component(.weekday, from: Date()) == 7 {
            return nil
        } else {
              let start = schedule!.first!
            let end = schedule!.last!
            if let interval = Calendar.current.dateComponents([.minute], from: start, to: end).minute {
                return interval
            } else {
                return nil
            }
            
            
        }
    }
   
}
