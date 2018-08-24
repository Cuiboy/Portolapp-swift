//
//  my_stringToDateFormatter.swift
//  PHS App
//
//  Created by Patrick Cui on 7/31/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension String
{
    func my_stringToDateFormatter(dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)!
    }
    
}
