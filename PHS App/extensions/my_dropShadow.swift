//
//  my_dropShadow.swift
//  PHS App
//
//  Created by Patrick Cui on 7/22/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit





extension UIView {
    func my_dropShadow() {
        let size = layer.frame.size.height
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: size * 0.04, height: size * 0.04)
        self.layer.shadowRadius = size * 0.05
        self.layer.shadowOpacity = 0.8
    }
    
  
}
