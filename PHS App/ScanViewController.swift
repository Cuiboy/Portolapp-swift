//
//  ScanViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/14/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import AVFoundation

class ScanViewController: RSCodeReaderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.yellow.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type.rawValue + " value=" + barcode.stringValue!)
            }
        }
    }
}
