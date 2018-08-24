//
//  my_boolToLabel.swift
//  PHS App
//
//  Created by Patrick Cui on 8/2/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
extension Bool {
    func startEndLabelFromBool() -> String {
        if self {
            return "STARTS"
        } else {
            return "ENDS"
        }
    }
}
