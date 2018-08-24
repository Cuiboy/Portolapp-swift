//
//  my_UTC.swift
//  PHS App
//
//  Created by Patrick Cui on 8/6/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
extension Date {
    func UTC() -> Date {
        if let date = Calendar.current.date(byAdding: .hour, value: UTCDifference(), to: self) {
            return date
        } else {
            return Date()
        }
      
    }
}
