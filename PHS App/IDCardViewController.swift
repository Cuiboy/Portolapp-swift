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
    var thisUser = User()
    @IBOutlet weak var houseHeader: UILabel!
    @IBOutlet weak var gradeHeader: UILabel!
    @IBOutlet weak var shortIDHeader: UILabel!
    
    func autoResizeUI() {
       let subviews: [UIView] = [nameLabel, barcode, gradeHeader, shortIDHeader, houseHeader, gradeLabel, shortID, house, longID]
        for view in subviews {
            view.alpha = 1
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        let userRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let request = try PersistentService.context.fetch(userRequest)
            if request.count > 0 {
                let object = request.first!
                thisUser = object
                if object.first != nil && object.longID > 100000000 {
                    navigationBar.topItem?.rightBarButtonItem = editButton
                    autoResizeUI()
                    gradeLabel.text = String(object.grade)
                    nameLabel.text = "\(object.first!) \(object.last!)"
                    shortID.text = String(object.shortID)
                    house.text = object.house?.uppercased()
                    longID.text = String(object.longID)
                    barcode.image = RSUnifiedCodeGenerator.shared.generateCode(String(object.longID), machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
                }
                
            } else {
                    navigationBar.topItem?.rightBarButtonItem = nil
                    let subviews: [UIView] = [nameLabel, barcode, gradeHeader, shortIDHeader, houseHeader, gradeLabel, shortID, house, longID]
                    for view in subviews {
                        view.alpha = 0
                    }
                    addCardView.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
                    addCardView.layer.cornerRadius = addCardView.bounds.height / 2
                    addCardLabel.bounds = CGRect(x: 0, y: 0, width: addCardView.frame.width.barRelativeToWidth, height: addCardView.frame.height.barRelativeToWidth)
                    addCardLabel.center = CGPoint(x: addCardView.frame.width.barRelativeToWidth / 2, y: addCardView.frame.height.relativeToWidth / 2)
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
            
                
            }
             
         catch {
            
        }
    }
    
   

    @objc func addCardTapped() {
        performSegue(withIdentifier: "showNameInput", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToIDCard(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToIDCard" {
            let updateRequest: NSFetchRequest<User> = User.fetchRequest()
            do {
                let request = try PersistentService.context.fetch(updateRequest)
                if let object = request.first {
                    autoResizeUI()
                    gradeLabel.text = String(object.grade)
                    nameLabel.text = "\(object.first!) \(object.last!)"
                    shortID.text = String(object.shortID)
                    house.text = object.house?.uppercased()
                    longID.text = String(object.longID)
                    barcode.image = RSUnifiedCodeGenerator.shared.generateCode(String(object.longID), machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue)
                    navigationBar.topItem?.rightBarButtonItem = editButton
        
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
