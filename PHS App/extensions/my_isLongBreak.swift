//
//  my_isLongBreak.swift
//  PHS App
//
//  Created by Patrick Cui on 9/4/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit
//FOR NOTIFICATION PURPOSES ONLY
extension Date {
    var isLongBreak: Bool {
        switch Calendar.current.component(.month, from: self) {
        case 11:
            if Calendar.current.component(.day, from: self) == 22 || Calendar.current.component(.day, from: self) == 23 {
                return true
            } else {
                return false
            }
        case 12:
            if Calendar.current.component(.day, from: self) >= 25 && Calendar.current.component(.day, from: self) <= 31 {
                return true
            } else
            {
                return false
            }
        case 1:
            if Calendar.current.component(.day, from: self) >= 1 && Calendar.current.component(.day, from: self) <= 4 {
                return true
            } else {
                return false
            }
        case 4:
            if Calendar.current.component(.day, from: self) >= 1 && Calendar.current.component(.day, from: self) <= 5 {
                return true
            } else {
                return false
            }
        default: return false
            
        }
       
    }
}
