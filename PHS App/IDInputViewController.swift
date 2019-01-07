//
//  IDInputViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import TextFieldEffects
import RSBarcodes_Swift
import AVFoundation
import CoreData

class IDInputViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var yourID: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBAction func previousTapped(_ sender: Any) {
        if isFreshLaunch {
            _ = navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
    
    @IBOutlet weak var shortIDTextField: HoshiTextField!
    @IBOutlet weak var longIDTextField: HoshiTextField!
    @IBOutlet weak var scanIDView: UIView!
    @IBAction func skipTapped(_ sender: Any) {
        if isFreshLaunch {
            let ac = UIAlertController(title: "Skip this page?", message: "Entering your ID number can save your ID card to your device in case you forget to bring it.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Skip", style: .default, handler: { (_) in
                self.shortID = nil
                self.longID = nil
                self.performSegue(withIdentifier: "skipToClass", sender: nil)
                
            }))
            ac.addAction(UIAlertAction(title: "Stay", style: .cancel))
            present(ac, animated: true)
        } else {
            performSegue(withIdentifier: "cancelToIDCard", sender: nil)
        }
      
    }
    @IBAction func nextTapped(_ sender: Any) {
        if shortIDTextField.text != nil && longIDTextField != nil {
            shortID = Int(shortIDTextField.text!)
            longID = Int(longIDTextField.text!)
        }
        if shortID != nil && longID != nil {
          
            if isFreshLaunch {
                  saveData()
                performSegue(withIdentifier: "nextToClass", sender: nil)

            } else {
                if isPageEditing {
                    saveEdits()
                    performSegue(withIdentifier: "unwindToIDCard", sender: nil)
                } else {
                    saveData()
                    performSegue(withIdentifier: "unwindToIDCard", sender: nil)
                }
               
            }
        } else {
           let ac = UIAlertController(title: "Missing fields", message: "Make sure you fill in all fields before continuing.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    func saveData() {
        let user = User(context: PersistentService.context)
        user.first = first
        user.last = last
        user.grade = Int16(grade ?? 0)
        user.house = house
        user.shortID = Int32(shortID ?? 0)
        user.longID = Int32(longID ?? 0)
        PersistentService.saveContext()
    }
    func saveEdits() {
        let updateRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
          let request = try PersistentService.context.fetch(updateRequest)
            if let user = request.first {
                let shortIDEdit = Int32(shortID ?? 0)
                let longIDEdit = Int32(longID ?? 0)
                user.setValue(first, forKey: "first")
                user.setValue(last, forKey: "last")
                user.setValue(grade, forKey: "grade")
                user.setValue(house, forKey: "house")
                user.setValue(shortIDEdit, forKey: "shortID")
                user.setValue(longIDEdit, forKey: "longID")
                PersistentService.saveContext()
            }
        } catch {
            
        }
       
        
    }
    
    var first: String?
    var last: String?
    var grade: Int?
    var house: String?
    var shortID: Int?
    var longID: Int?
    
    var scanLabel = UILabel()
    var barImageView = UIImageView()
    var rescan = UIButton()
    var delete = UIButton()
    var longIDLabel = UILabel()
    
    var isFreshLaunch = true
    var isPageEditing = false 
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        yourID.font = yourID.font.withSize(CGFloat(25).relativeToWidth)
        previousButton.titleLabel?.font = previousButton.titleLabel?.font.withSize(CGFloat(15).relativeToWidth)
      
        
        scanLabel.bounds = CGRect(x: 0, y: 0, width: scanIDView.frame.width * 0.8, height: scanIDView.frame.height * 0.8)
        scanLabel.center = CGPoint(x: scanIDView.frame.width / 2, y: scanIDView.frame.height / 2)
        scanLabel.textAlignment = .center
        scanLabel.text = "SCAN ID CARD"
        scanLabel.textColor = UIColor.white
        scanLabel.font = UIFont(name: "Lato-Regular", size: CGFloat(16))
        scanIDView.addSubview(scanLabel)
        scanIDView.clipsToBounds = true
        scanIDView.layer.cornerRadius = scanIDView.frame.width / 2
        scanIDView.backgroundColor = UIColor.white.withAlphaComponent(0)
        scanIDView.layer.borderWidth = 2
        scanIDView.layer.borderColor = UIColor.white.cgColor
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scanIDTapped))
        gestureRecognizer.delegate = self
        scanIDView.addGestureRecognizer(gestureRecognizer)
        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
       self.view.addSubview(longIDLabel)
            self.view.addSubview(rescan)
        self.view.addSubview(delete)
        if isFreshLaunch == false {
            skipButton.setTitle("CANCEL", for: .normal)
            nextButton.setTitle("SAVE", for: .normal)
                    }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if isFreshLaunch == false {
            skipButton.titleLabel!.text = "CANCEL"
        }
        if isPageEditing {
            if shortID != nil {
                shortIDTextField.text = String(shortID!)
            }
            if longID != nil {
                 longIDTextField.text = String(longID!)
                  generateBarcode(string: String(longID!))
            }
           
          
        }

    }
    
    @objc func screenTapped() {
        if shortIDTextField.isEditing || longIDTextField.isEditing {
            if shortIDTextField.text != nil {
                shortID = Int(shortIDTextField.text!)
                shortIDTextField.resignFirstResponder()
            } else {
                shortID = nil
                shortIDTextField.resignFirstResponder()
            }
            if longIDTextField.text != nil {
   
                if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: longIDTextField.text!)) {
        
                    if let number = Int(longIDTextField.text!) {
                        if number > 100000000 && number < 999999999 {
                            longID = number
                            generateBarcode(string: String(longID!))
                            longIDTextField.resignFirstResponder()
                            
                        } else {
                            let ac = UIAlertController(title: "Not a valid ID number", message: "Your student ID number must be 9 digits long", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                self.longIDTextField.resignFirstResponder()
                                self.longIDTextField.text = nil
                                
                                
                            }))
                            present(ac, animated: true)
                        }
                    } else {
                        longID = nil
                        
                        longIDTextField.resignFirstResponder()
                        self.barImageView.image = nil
                        self.barImageView.alpha = 0
                        self.rescan.alpha = 0
                        self.delete.alpha = 0
                        self.longIDLabel.alpha = 0
                        self.scanIDView.alpha = 1
                    }
                  
                } else {
               
                    let ac = UIAlertController(title: "Not a valid ID number", message: "Your student ID number must be 9 digits long and contain only numbers", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.longIDTextField.text = nil
                    }))
                    present(ac, animated: true)
                    longIDTextField.resignFirstResponder()
                }
                

            } else {
                longID = nil
                
                longIDTextField.resignFirstResponder()
            }
        }
        
        
        }
        
    

    @objc func scanIDTapped() {
        scanIDView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        performSegue(withIdentifier: "firstScan", sender: nil)
      
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == shortIDTextField {
            if textField.text != nil {
               shortID = Int(textField.text!)
            }
            shortIDTextField.resignFirstResponder()
        } else if textField == longIDTextField {
            if textField.text != nil {
                 generateBarcode(string: String(longID!))
                 longID = Int(textField.text!)
            }
          
            longIDTextField.resignFirstResponder()
        }
    }
    
   
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        let source = segue.source as? FirstScanViewController
        scanIDView.backgroundColor = UIColor.white.withAlphaComponent(0)
        if source!.longID != nil {
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: source!.longID!)) {
                longID = Int(source!.longID!)
                if longID! > 100000000 && longID! < 999999999 {
                    generateBarcode(string: String(longID!))
                } else {
                    let ac = UIAlertController(title: "Not a valid ID number", message: "Your student ID number must be 9 digits long", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.longIDTextField.text = nil
                    }))
                    present(ac, animated: true)
                }
            } else {
                let ac = UIAlertController(title: "Not a valid ID number", message: "Your student ID number must be 9 digits long and contain only numbers", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.longIDTextField.text = nil
                }))
                present(ac, animated: true)
            }
            
        } else {
            self.longID = nil
        }
        
    }

    func generateBarcode(string: String) {
        longIDTextField.text = string

        if let scannedCode = RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue) {
            barImageView.bounds = CGRect(x: 0, y: 0, width: CGFloat(240).relativeToWidth, height: CGFloat(80).relativeToWidth)
            barImageView.center = scanIDView.center
            barImageView.image = scannedCode
            self.view.addSubview(barImageView)
            self.scanIDView.alpha = 0
            longIDLabel.bounds = CGRect(x: 0, y: 0, width: CGFloat(240).relativeToWidth, height: CGFloat(30).relativeToWidth)
            longIDLabel.text = string
            longIDLabel.textColor = UIColor.white
            longIDLabel.font = UIFont(name: "Lato-Light", size: CGFloat(24).relativeToWidth)
            longIDLabel.textAlignment = .center
            
            longIDLabel.center = CGPoint(x: barImageView.center.x, y: barImageView.center.y + CGFloat(60).relativeToWidth)
            rescan.bounds = CGRect(x: 0, y: 0, width: CGFloat(120).relativeToWidth, height: CGFloat(30).relativeToWidth)
            rescan.center = CGPoint(x: barImageView.center.x - CGFloat(50).relativeToWidth, y: barImageView.center.y + CGFloat(120).relativeToWidth)
            rescan.setTitle("Rescan ID Card", for: .normal)
            rescan.titleLabel!.font = UIFont(name: "Lato-Light", size: CGFloat(15).relativeToWidth)
            rescan.titleLabel!.textColor = UIColor.white
            rescan.titleLabel!.textAlignment = .center
            
            rescan.addTarget(self, action: #selector(rescanTapped), for: .touchUpInside)
            
            delete.bounds = CGRect(x: 0, y: 0, width: CGFloat(120).relativeToWidth, height: CGFloat(30).relativeToWidth)
            delete.center = CGPoint(x: barImageView.center.x + CGFloat(75).relativeToWidth, y: barImageView.center.y + CGFloat(120).relativeToWidth)
            delete.setTitle("Discard", for: .normal)
            delete.titleLabel!.font = UIFont(name: "Lato-Light", size: CGFloat(15).relativeToWidth)
            delete.titleLabel!.textColor = UIColor.white
            delete.titleLabel!.textAlignment = .center
            
            delete.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
            self.barImageView.alpha = 1
            self.rescan.alpha = 1
            self.delete.alpha = 1
            self.longIDLabel.alpha = 1
            
        }
        
    }
    
    @objc func rescanTapped() {
             performSegue(withIdentifier: "firstScan", sender: nil)
    }
    
    @objc func deleteTapped() {
        let ac = UIAlertController(title: "Discard Scanned ID Card?", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.longIDTextField.text = nil
            self.barImageView.image = nil
            self.barImageView.alpha = 0
            self.rescan.alpha = 0
            self.delete.alpha = 0
            self.longIDLabel.alpha = 0
            self.scanIDView.alpha = 1
        }))
       ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
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
