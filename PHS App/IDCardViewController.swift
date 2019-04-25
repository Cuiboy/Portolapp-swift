//
//  IDCardViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/12/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes_Swift
import AVFoundation
import LocalAuthentication

class IDCardViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "editNameInput", sender: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var shortID: UILabel!
    @IBOutlet weak var house: UILabel!
    @IBOutlet weak var barcode: UIImageView!
    @IBOutlet weak var longID: UILabel!
    @IBOutlet weak var addCardView: UIView!
    var addCardLabel = UILabel()
//    var thisUser = User(context: PersistentService.context)
    var thisUser = UserInfo()
    @IBOutlet weak var houseHeader: UILabel!
    @IBOutlet weak var gradeHeader: UILabel!
    @IBOutlet weak var shortIDHeader: UILabel!
    @IBOutlet weak var asbView: UILabel!
    @IBOutlet weak var stickerView: UILabel!
    
  func faceIDAction() {
    
        let context = LAContext()
        let localizedReasonString = "Secure your information using Face ID and Touch ID."
        var authError: NSError?
        if #available(iOS 8.0, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonString) { (success, error) in
                    DispatchQueue.main.async {
                        if success {
                            self.loadIDCard()
                        } else {
                           self.authenticateUsingShortID()
                        }
                    }
                }
            } else {
                authenticateUsingShortID()
            }
        } else {
            authenticateUsingShortID()
    }
    }
    
    func loadIDCard() {
        navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
        let subviews: [UIView] = [nameLabel, barcode, gradeHeader, shortIDHeader, houseHeader, gradeLabel, shortID, house, longID, asbView, stickerView]
        for view in subviews {
            UIView.animate(withDuration: 0.5) {
                view.alpha = 1
            }
        }
    }
    
    func authenticateUsingShortID() {
        let ac = UIAlertController(title: "Enter School Short ID", message: "enter short ID to verify your identity.", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].keyboardType = .numberPad
        let submitAction = UIAlertAction(title: "Verify", style: .default, handler: { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            if answer.text != nil {
                if answer.text! == self.shortID.text! {
                    self.loadIDCard()
                } else {
                    self.failVerify(isShortID: true)
                    answer.text = ""
                }
            } else {
                self.failVerify(isShortID: true)
                answer.text = ""
            }
            
            })
        ac.addAction(submitAction)
       
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
        present(ac, animated: true)
        
    }
    
    func failVerify(isShortID: Bool) {
        var messageString = String()
        if isShortID {
           messageString = "Short ID"
        } else {
            messageString = "Code"
        }
        let ac = UIAlertController(title: "Incorrect \(messageString)", message: "You have entered an incorrect \(messageString), please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            if isShortID {
                self.authenticateUsingShortID()
            } else {
                
            }
        }))
        present(ac, animated: true)
    }
    
    
    func autoResizeUI() {
       let subviews: [UIView] = [nameLabel, barcode, gradeHeader, shortIDHeader, houseHeader, gradeLabel, shortID, house, longID, asbView, stickerView]
        for view in subviews {
            view.alpha = 0
        }
        addCardView.alpha = 0
        nameLabel.font = nameLabel.font.withSize(CGFloat(31).relativeToWidth)
        gradeHeader.font = gradeHeader.font.withSize(CGFloat(19).relativeToWidth)
        shortIDHeader.font = shortIDHeader.font.withSize(CGFloat(19).relativeToWidth)
        houseHeader.font = houseHeader.font.withSize(CGFloat(19).relativeToWidth)
        gradeLabel.font = gradeLabel.font.withSize(CGFloat(60).relativeToWidth)
        shortID.font = shortID.font.withSize(CGFloat(60).relativeToWidth)
        house.font = house.font.withSize(CGFloat(60).relativeToWidth)
        longID.font = longID.font.withSize(CGFloat(31).relativeToWidth)
        asbView.isUserInteractionEnabled = true
        asbView.isHidden = true
        stickerView.isHidden = true
        stickerView.isUserInteractionEnabled = true
        let asbGesture = UITapGestureRecognizer(target: self, action: #selector(asbTapped))
        asbGesture.delegate = self
        asbView.addGestureRecognizer(asbGesture)
        
        let stickerGesture = UITapGestureRecognizer(target: self, action: #selector(stickerTapped))
        stickerGesture.delegate = self
        stickerView.addGestureRecognizer(stickerGesture)
    }
    
    @objc func asbTapped() {
        if UserDefaults.standard.bool(forKey: "asbActivated") {
            let ac = UIAlertController(title: "ASB Card", message: "You currenlty have ASB feature activated, you may deactivate it if you wish.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Deactivate", style: .destructive, handler: { (_) in
                let sheet = UIAlertController(title: "Deactivate ASB Feature", message: "Are you sure?", preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "Deactivate", style: .destructive, handler: { (_) in
                    UserDefaults.standard.set(false, forKey: "asbActivated")
                    self.setStandards()
                }))
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(sheet, animated: true)

            }))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Enter Code", message: "Show your advisement teacher your ID card to activate ASB on this device.", preferredStyle: .alert)
            ac.addTextField()
            let submitAction = UIAlertAction(title: "Verify", style: .default, handler: { [unowned ac] _ in
                let answer = ac.textFields![0]
                
                if answer.text != nil {
                    if answer.text! == "app-activate-asb-now" {
                        UserDefaults.standard.set(true, forKey: "asbActivated")
                        self.setStandards()
                    } else {
                        self.failVerify(isShortID: false)
                        answer.text = ""
                    }
                } else {
                    self.failVerify(isShortID: false)
                    answer.text = ""
                }
                
            })
            ac.addAction(submitAction)
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(ac, animated: true)
        }
       
    }
    
    @objc func stickerTapped() {
        if UserDefaults.standard.bool(forKey: "stickerActivated") {
            let ac = UIAlertController(title: "Sticker", message: "You currenlty have sticker feature activated, you may deactivate it if you wish.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            ac.addAction(UIAlertAction(title: "Deactivate", style: .destructive, handler: { (_) in
                let sheet = UIAlertController(title: "Deactivate Sticker Feature", message: "Are you sure?", preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "Deactivate", style: .destructive, handler: { (_) in
                    UserDefaults.standard.set(false, forKey: "stickerActivated")
                    self.setStandards()
                }))
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(sheet, animated: true)
            }))
            present(ac, animated: true)

        } else {
            let ac = UIAlertController(title: "Enter Code", message: "Show your advisement teacher your ID card to activate sticker on this device.", preferredStyle: .alert)
            ac.addTextField()
            let submitAction = UIAlertAction(title: "Verify", style: .default, handler: { [unowned ac] _ in
                let answer = ac.textFields![0]
                
                if answer.text != nil {
                    if answer.text! == "app-activate-sticker-now" {
                        UserDefaults.standard.set(true, forKey: "stickerActivated")
                        self.setStandards()
                    } else {
                        self.failVerify(isShortID: false)
                        answer.text = ""
                    }
                } else {
                    self.failVerify(isShortID: false)
                    answer.text = ""
                }
                
            })
            ac.addAction(submitAction)
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(ac, animated: true)
        }
       
    }
    
    func setStandards() {
        if UserDefaults.standard.bool(forKey: "asbActivated") {
            print("asbTrue")
            asbView.font = UIFont(name: "Lato-Bold", size: asbView.font.pointSize)
            asbView.textColor = UIColor(red: 0.376, green: 0.271, blue: 0.529, alpha: 1)
            
        } else {
            print("asbFalse")

            asbView.textColor = UIColor.lightGray
        }
        
        if UserDefaults.standard.bool(forKey: "stickerActivated") {
            print("stickerTrue")

            stickerView.font = UIFont(name: "Lato-Bold", size: asbView.font.pointSize)
            stickerView.textColor = UIColor(red: 0.376, green: 0.271, blue: 0.529, alpha: 1)
        } else {
            print("stickerFalse")
            stickerView.textColor = UIColor.lightGray
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let notInitial = UserDefaults.standard.bool(forKey: "isInitial")
        if !notInitial {
            print("INITIAL")

             UserDefaults.standard.set(true, forKey: "isInitial")
            UserDefaults.standard.set(false, forKey: "asbActivated")
            UserDefaults.standard.set(false, forKey: "stickerActivated")
        }
       
    
      
        
        
        navigationBar.my_setNavigationBar()
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let request = try PersistentService.context.fetch(userRequest)
            if request.count > 0 {
                let object = request.first!
               
                if object.first != nil && object.longID > 100000000 {
                    navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
                    thisUser.first = object.first!
                    thisUser.last = object.last!
                    thisUser.longID = object.longID
                    thisUser.shortID = object.shortID
                    thisUser.grade = object.grade
                    thisUser.house = object.house!
                    navigationBar.topItem?.rightBarButtonItem = editButton
                    autoResizeUI()
                    setStandards()
                    
                    gradeLabel.text = String(object.grade)
                    nameLabel.text = "\(object.first!) \(object.last!)"
                    shortID.text = String(object.shortID)
                    house.text = object.house?.uppercased()
                    longID.text = String(object.longID)
                    barcode.image = RSUnifiedCodeGenerator.shared.generateCode(String(object.longID), machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
                    
                    
                    
                    faceIDAction()
                }
                
            } else {
                    navigationBar.topItem?.rightBarButtonItem = nil
                    let subviews: [UIView] = [nameLabel, barcode, gradeHeader, shortIDHeader, houseHeader, gradeLabel, shortID, house, longID]
                    for view in subviews {
                        view.alpha = 0
                    }
                
                
                }
            
                
            }
             
         catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewWillLayoutSubviews() {
        addCardView.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
        addCardView.layer.cornerRadius = addCardView.bounds.height / 2
        addCardLabel.bounds = CGRect(x: 0, y: 0, width: addCardView.frame.width, height: addCardView.frame.height)
        addCardLabel.center = CGPoint(x: addCardView.frame.width / 2, y: addCardView.frame.height / 2)
        addCardLabel.text = "FILL IN YOUR INFO"
        addCardLabel.textAlignment = .center
        addCardLabel.font = UIFont(name: "Lato-Bold", size: CGFloat(17).relativeToWidth)
        addCardLabel.textColor = UIColor.white
        addCardView.addSubview(addCardLabel)
        addCardLabel.my_dropShadow()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCardTapped))
        gestureRecognizer.delegate = self
        addCardView.addGestureRecognizer(gestureRecognizer)
    }
    
   

    @objc func addCardTapped() {
        performSegue(withIdentifier: "showNameInput", sender: nil)
    }
    
    
    
    @IBAction func unwindToIDCard(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToIDCard" {
        
     
            let updateRequest: NSFetchRequest<User> = User.fetchRequest()
            do {
                let request = try PersistentService.context.fetch(updateRequest)
                
                if let object = request.first {
                    autoResizeUI()
                    thisUser.first = object.first!
                    thisUser.last = object.last!
                    thisUser.longID = object.longID
                    thisUser.shortID = object.shortID
                    thisUser.grade = object.grade
                    thisUser.house = object.house!
                    gradeLabel.text = String(object.grade)
                    nameLabel.text = "\(object.first!) \(object.last!)"
                    shortID.text = String(object.shortID)
                    house.text = object.house?.uppercased()
                    longID.text = String(object.longID)
                    barcode.image = RSUnifiedCodeGenerator.shared.generateCode(String(object.longID), machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
                    navigationBar.topItem?.rightBarButtonItem = editButton
                    loadIDCard()
                    setStandards()
                    asbView.isUserInteractionEnabled = true
                    stickerView.isUserInteractionEnabled = true

                    
                }
                
            } catch {
                
            }
            
        }
    }

    @IBAction func cancelToIDCard(segue: UIStoryboardSegue) {
        if segue.identifier == "cancelToIDCard" {
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNameInput" {
            if let vc = segue.destination as? NameInputViewController {
                vc.isFreshLaunch = false
            }
        } else if segue.identifier == "editNameInput" {
            if let vc = segue.destination as? NameInputViewController {
                vc.isFreshLaunch = false
                vc.isPageEditing = true
                vc.first = thisUser.first
                vc.last = thisUser.last
                vc.house = thisUser.house
                vc.grade = Int(thisUser.grade)
                vc.shortID = String(thisUser.shortID)
                vc.longID = String(thisUser.longID)
               
            }
        }
    }
 

}
