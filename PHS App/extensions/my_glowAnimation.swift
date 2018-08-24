//
//  my_glowAnimation.swift
//  PHS App
//
//  Created by Patrick Cui on 8/22/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func my_glow() {
       
        let size = layer.frame.size.height
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: size * 0.24, height: size * 0.24)
        self.layer.shadowRadius = size * 0.35
        self.layer.shadowOpacity = 0.8
    }
    
    func my_glowOnTap() {
        UIView.animate(withDuration: 0.25, delay: 0, animations: {
            self.alpha = 0.4
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                self.alpha = 1
            })
        }
        
        
      
    }
}
