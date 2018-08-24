//
//  File.swift
//  PHS App
//
//  Created by Patrick Cui on 8/4/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func viewFadeIn() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    func viewFadeOut() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
}
