//
//  my_UTCTimeDifference.swift
//  PHS App
//
//  Created by Patrick Cui on 8/3/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

func UTCDifference() -> Int {
    
let offset = Double(TimeZone.current.secondsFromGMT())
    
    return Int(offset / 3600)
    
}
