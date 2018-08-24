//
//  my_parentViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/16/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
}
