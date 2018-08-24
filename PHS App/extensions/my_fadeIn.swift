//
//  File.swift
//  PHS App
//
//  Created by Patrick Cui on 8/3/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func fadeIn() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
}
