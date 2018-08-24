//
//  my_customDateFormatter.swift
//  PHS App
//
//  Created by Patrick Cui on 7/28/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension String {
    func my_customDateFormatter() -> Date {
       let firstArray = self.components(separatedBy: "/")
        if firstArray.count < 3 {
            print(firstArray)
            return Date.distantPast
        }
        
        let year = firstArray[0]
        var month = String()
        var day = String()
        
        if let monthNumber = Int(firstArray[1]) {
            if monthNumber < 1 || monthNumber > 12 {
                return Date.distantPast
            } else if monthNumber < 10 {
                month = "0\(monthNumber)"
            } else {
                month = "\(monthNumber)"
            }
        }
        
        if let dayNumber = Int(firstArray[2]) {
            if dayNumber < 1 || dayNumber > 31 {
                return Date.distantPast
            } else if dayNumber < 10 {
                day = "0\(dayNumber)"
            } else {
                day = "\(dayNumber)"
            }
        }
        
        let stringDate = "\(year)-\(month)-\(day)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: stringDate) {
            return date
        } else {
            return Date.distantPast
        }
        
       
        
        
    }
    

}
