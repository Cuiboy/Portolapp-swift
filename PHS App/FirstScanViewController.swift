//
//  FirstScanViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import AVFoundation

class FirstScanViewController: RSCodeReaderViewController {

    @IBOutlet weak var frameView: UIView!
    @IBAction func buttonTapped(_ sender: Any) {
        longID = nil
      performSegue(withIdentifier: "backToID", sender: nil)
    }
    
    var longID: String?
    var shouldReturn = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            //continue
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                
                } else {
                    let ac = UIAlertController (title: "No Camera Usage Permission", message: "You have denied the app's camera usage, please go to settings to double-check camera usage permission.?", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                
                            })
                        }
                    }
                    ac.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                        self.dismiss(animated: true)
                    })
                    ac.addAction(cancelAction)
                    
                   self.present(ac, animated: true, completion: nil)
                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameView.backgroundColor = UIColor.white.withAlphaComponent(0)
        frameView.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 2
        
      
      
        
        
        self.focusMarkLayer.strokeColor = UIColor.yellow.cgColor
        
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
      
        
        
        self.barcodesHandler = { barcodes in
            let barcode = barcodes.first!
           
            if self.shouldReturn {
                self.longID = barcode.stringValue!
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.performSegue(withIdentifier: "backToID", sender: nil)
                })
            }
            self.shouldReturn = false

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
