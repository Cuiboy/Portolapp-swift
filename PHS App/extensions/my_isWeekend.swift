//
//  my_isWeekend.swift
//  PHS App
//
//  Created by Patrick Cui on 8/2/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension Date {
    func isWeekend() -> Bool {
        if Calendar.current.component(.weekday, from: self) == 1 || Calendar.current.component(.weekday, from: self) == 7 {
            return true
        } else {
            return false
        }
        
    }
}
