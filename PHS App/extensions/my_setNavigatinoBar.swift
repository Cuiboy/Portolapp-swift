//
//  my_setNavigationBar.swift
//  PHS App
//
//  Created by Patrick Cui on 7/25/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func my_setNavigationBar() {
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
    }
    
    static func createNavigationBar() -> UINavigationBar {
        let navigationBar = UINavigationBar()
        navigationBar.my_setNavigationBar()
        return navigationBar
    }
    
}
