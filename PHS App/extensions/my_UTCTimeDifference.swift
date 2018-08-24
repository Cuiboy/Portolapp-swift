//
//  my_UTCTimeDifference.swift
//  PHS App
//
//  Created by Patrick Cui on 8/3/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func UTCDifference() -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "H"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    let UTCstring = formatter.string(from: Date().noon)
    let UTC = Int(UTCstring)!
    
    let currentFormatter = DateFormatter()
    currentFormatter.dateFormat = "H"
    let currentString = currentFormatter.string(from: Date().noon)
    let current = Int(currentString)!
    
    return UTC - current
    
}
