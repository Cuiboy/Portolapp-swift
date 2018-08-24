//
//  my_adjustFontSize.swift
//  PHS App
//
//  Created by Patrick Cui on 8/9/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


extension CGFloat {
    var relativeToWidth: CGFloat {
        if (self / 375) * UIScreen.main.bounds.width < self {
            return (self / 375) * UIScreen.main.bounds.width
        } else {
            return (self / UIScreen.main.bounds.width) * UIScreen.main.bounds.width
        }
        
    }
    
    var barRelativeToWidth: CGFloat {
        return (self / 375) * UIScreen.main.bounds.width
    }
    
  
}

extension Int {
    var relativeToWidth: Int {
        if (self / 375) * Int(UIScreen.main.bounds.width) < self {
            return Int((self / 375) * Int(UIScreen.main.bounds.width))
        } else {
            return Int((self / Int(UIScreen.main.bounds.width)) * Int(UIScreen.main.bounds.width))
        }
        
    }
    
    var barRelativeToWidth: Int {
        return (self / 375) * Int(UIScreen.main.bounds.width)
    }
    
    
}

