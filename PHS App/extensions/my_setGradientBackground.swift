//
//  my_setGradientBackground.swift
//  PHS App
//
//  Created by Patrick Cui on 7/22/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func my_setGradientBackground(colorOne: UIColor, colorTwo: UIColor, inBounds: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = inBounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
