//
//  my_daysAwayFromToday.swift
//  PHS App
//
//  Created by Patrick Cui on 7/29/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

 func my_daysAwayFromToday(date: Date) -> Int? {
    let today = Calendar.current.startOfDay(for: Date())
    let dateGet = Calendar.current.startOfDay(for: date)
    if let interval = Calendar.current.dateComponents([.day], from: today, to: dateGet).day {
        return interval
    } else {
        return nil
    }
}
