//
//  removingDuplicates.swift
//  PHS App
//
//  Created by Patrick Cui on 8/10/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
