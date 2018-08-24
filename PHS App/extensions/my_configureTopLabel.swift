//
//  my_configureTopLabel.swift
//  PHS App
//
//  Created by Patrick Cui on 8/2/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func timeStringFromDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "h:mm"
    let startTimeString = formatter.string(from: date)
    return startTimeString
}


