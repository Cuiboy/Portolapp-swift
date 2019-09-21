//
//  NameInputViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/18/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import TextFieldEffects
import CoreData

class NameInputViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var yourName: UILabel!
    @IBOutlet weak var yourGrade: UILabel!
    @IBOutlet weak var yourHouse: UILabel!
    @IBOutlet weak var gradeCollectionView: UICollectionView!
    @IBOutlet weak var houseCollectionView: UICollectionView!
    @IBOutlet weak var firstName: HoshiTextField!
    @IBOutlet weak var lastName: HoshiTextField!
    @IBAction func nextTapped(_ sender: Any) {
        if first != nil && last != nil && grade != nil && house != nil {
            if isFreshLaunch {
                performSegue(withIdentifier: "nextToID", sender: nil)

            } else {
                if isPageEditing {
                    performSegue(withIdentifier: "editingToID", sender: nil)
                } else {
                    performSegue(withIdentifier: "nameToID", sender: nil)

                }
            }
        } else {
           
            let ac = UIAlertController(title: "Missing Fields", message: "Some fields are empty, make sure they are filled in in order to continue.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    @IBAction func skipTapped(_ sender: Any) {
        if isFreshLaunch {
            let ac = UIAlertController(title: "Skip this page?", message: "Entering general information about yourself can make the app experience more personalized.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Skip", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "skipToID", sender: nil)
            }))
            ac.addAction(UIAlertAction(title: "Stay", style: .cancel))
            present(ac, animated: true)
        } else {
           dismiss(animated: true)
        }
      
    }
    var first: String?
    var last: String?
    var grade: Int?
    var house: String?
    var longID: String?
    var shortID: String?
    
   var gradeArray = [9, 10, 11, 12]
    var houseArray = ["Hercules", "Orion", "Pegasus", "Poseidon"]
    var isFreshLaunch = true
    var isPageEditing = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextToID" {
            let vc = segue.destination as! IDInputViewController
            vc.first = first
            vc.last = last
            vc.house = house
            vc.grade = grade
        } else if segue.identifier == "skipToID" {
            let vc = segue.destination as! IDInputViewController
            vc.first = nil
            vc.last = nil
            vc.house = nil
            vc.grade = nil
        } else if segue.identifier == "nameToID" {
            let vc = segue.destination as! IDInputViewController
            vc.first = first
            vc.last = last
            vc.house = house
            vc.grade = grade
            vc.isFreshLaunch = false
        } else if segue.identifier == "editingToID" {
            let vc = segue.destination as! IDInputViewController
            vc.first = first
            vc.last = last
            vc.house = house
            vc.grade = grade
            vc.shortID = Int(shortID!)
            vc.longID = Int(longID!)
            vc.isFreshLaunch = false
            vc.isPageEditing = true
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        if collectionView == gradeCollectionView {
            return 4
        } else if collectionView == houseCollectionView {
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == gradeCollectionView {
            return CGSize(width: CGFloat(55).relativeToWidth, height: CGFloat(55).relativeToWidth)
        } else if collectionView == houseCollectionView {
            return CGSize(width: UIScreen.main.bounds.width / 3, height: CGFloat(60).relativeToWidth)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gradeCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grade", for: indexPath) as!GradeCollectionViewCell
                cell.label.text = "\(gradeArray[indexPath.item])"
            
            cell.label.textAlignment = .center
                cell.label.bounds = CGRect(x: 0, y: 0, width: CGFloat(55).relativeToWidth, height: CGFloat(55).relativeToWidth)
                cell.label.textColor = UIColor.white
                cell.label.font = UIFont(name: "Lato-Light", size: CGFloat(24).relativeToWidth)
                cell.label.center = CGPoint(x: cell.frame.width / 2, y: cell.frame.height / 2)
                cell.circle.bounds = CGRect(x: 0, y: 0, width: CGFloat(55).relativeToWidth, height: CGFloat(55).relativeToWidth)
                cell.circle.center = CGPoint(x: cell.frame.width / 2, y: cell.frame.height / 2)
                cell.circle.clipsToBounds = true
                cell.circle.layer.cornerRadius = cell.circle.frame.width / 2
                cell.circle.layer.borderColor = UIColor.white.cgColor
            cell.circle.layer.borderWidth = 1.5
                cell.circle.layer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
                cell.addSubview(cell.circle)
            cell.addSubview(cell.label)
            print(indexPath.item)
                return cell
                
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "house", for: indexPath) as! HouseCollectionViewCell
            cell.label.text = houseArray[indexPath.item].uppercased()
            cell.label.textAlignment = .center
            cell.label.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 3, height: CGFloat(55).relativeToWidth)
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont(name: "Lato-Light", size: CGFloat(20).relativeToWidth)
            cell.label.center = CGPoint(x: cell.frame.width / 2, y: cell.frame.height / 2)
            cell.roundedRect.bounds = CGRect(x: 0, y: 0, width: CGFloat(120).relativeToWidth, height: CGFloat(50).relativeToWidth)
            cell.roundedRect.center = CGPoint(x: cell.frame.width / 2, y: cell.frame.height / 2)
            cell.roundedRect.clipsToBounds = true
            cell.roundedRect.layer.cornerRadius = cell.roundedRect.frame.height / 2
            cell.roundedRect.layer.borderColor = UIColor.white.cgColor
            cell.roundedRect.layer.borderWidth = 1.5
            cell.roundedRect.layer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
            cell.addSubview(cell.roundedRect)
             cell.addSubview(cell.label)
          
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath)!
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
           self.collectionView(collectionView, didDeselectItemAt: indexPath)
            if collectionView == gradeCollectionView {
                grade = nil
            } else if collectionView == houseCollectionView {
                house = nil
            }
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == gradeCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)!
            
                grade = gradeArray[indexPath.item]
                
                if let item = cell as? GradeCollectionViewCell {
                    UIView.animate(withDuration: 0.3) {
                        item.label.textColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
                        item.circle.backgroundColor = UIColor.white.withAlphaComponent(1)
                    }
                    
                }
            
          
        } else {
            let cell = collectionView.cellForItem(at: indexPath)!

                house = houseArray[indexPath.item]
                
                if let item = cell as? HouseCollectionViewCell {
                    UIView.animate(withDuration: 0.3) {
                        item.label.textColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
                        item.roundedRect.backgroundColor = UIColor.white.withAlphaComponent(1)
                        
                    }

            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == gradeCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            
            if let item = cell as? GradeCollectionViewCell {
                UIView.animate(withDuration: 0.3) {
                    item.label.textColor = UIColor.white
                    item.circle.backgroundColor = UIColor.white.withAlphaComponent(0)
                }
                
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath)
            
            if let item = cell as? HouseCollectionViewCell {
                UIView.animate(withDuration: 0.3) {
                    item.label.textColor = UIColor.white
                    item.roundedRect.backgroundColor = UIColor.white.withAlphaComponent(0)
                    
                }
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstName {
            if textField.text == "" {
                first = nil
            } else {
                first = textField.text
                firstName.resignFirstResponder()
            }
           
        } else if textField == lastName {
            if textField.text == "" {
                last = nil
            } else {
                last = textField.text
                firstName.resignFirstResponder()
            }
           
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.gestureRecognizers?.first!.isEnabled = true
        if textField == lastName {
            first = firstName.text
        } else if textField == firstName {
            last = lastName.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstName {
            first = textField.text
           firstName.resignFirstResponder()
            self.view.gestureRecognizers?.first!.isEnabled = false
        } else if textField == lastName {
            last = textField.text
            lastName.resignFirstResponder()
            self.view.gestureRecognizers?.first!.isEnabled = false

        }
        return true
    }
    
    

    override var prefersHomeIndicatorAutoHidden: Bool {
    return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.delegate = self
        lastName.delegate = self
        gradeCollectionView.delegate = self
        houseCollectionView.delegate = self
        gradeCollectionView.dataSource = self
        houseCollectionView.dataSource = self 
        gradeCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0)
        houseCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0)
        gradeCollectionView.allowsMultipleSelection = false
        houseCollectionView.allowsMultipleSelection = false
        yourHouse.font = yourHouse.font.withSize(CGFloat(25).relativeToWidth)
        yourName.font = yourHouse.font.withSize(CGFloat(25).relativeToWidth)
        yourGrade.font = yourHouse.font.withSize(CGFloat(25).relativeToWidth)
        
        let gradeLayout = self.gradeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        gradeLayout.minimumInteritemSpacing = CGFloat(20).relativeToWidth
        gradeLayout.sectionInset = UIEdgeInsets.init(top: 0, left: CGFloat(30).relativeToWidth, bottom: 0, right: CGFloat(30).relativeToWidth)
    
        let houseLayout = self.houseCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        houseLayout.minimumInteritemSpacing = CGFloat(20).relativeToWidth
        houseLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 35, bottom: 0, right: 35)
        houseLayout.minimumLineSpacing = CGFloat(20).relativeToWidth
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.isEnabled = false
        
        if CheckInternet.Connection() {
            DispatchQueue.global(qos: .background).async {
                if localTeachers.count == 0 {
                    fetchTeachers()
                }
                DispatchQueue.main.async {
                    let fetchRequest: NSFetchRequest<Teachers> = Teachers.fetchRequest()
                    let sort = NSSortDescriptor(key: "last", ascending: true)
                    fetchRequest.sortDescriptors = [sort]
                    do {
                        let newRequest = try PersistentService.context.fetch(fetchRequest)
                        
                        savedTeachers = newRequest
                        if teachersAlphaDict.count == 0 {
                            generateAlphaDict()
                        }
                        if subjectsDictionary.count == 0 {
                            generateSubjectsDict()
                        }
                        
                    } catch {
                        
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "No Internet Connection", message: "Trouble loading certain data, make sure you are connected to the Internet. You may still continue the set-up process.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
      
            
          
        
       
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !isFreshLaunch {
            if isPageEditing {
                firstName.text = first
                lastName.text = last
                gradeCollectionView.selectItem(at: [0, grade! - 9], animated: true, scrollPosition: [])
                self.collectionView(self.gradeCollectionView, didSelectItemAt: [0, grade! - 9])
                
                
                var houseArrayIndex = Int()
                for i in 0...houseArray.count - 1 {
                    if houseArray[i] == house {
                        houseArrayIndex = i
                        break
                    }
                }
                houseCollectionView.selectItem(at: [0, houseArrayIndex], animated: true, scrollPosition: [])
                self.collectionView(self.houseCollectionView, didSelectItemAt: [0, houseArrayIndex])
                
                
            }
        }
    }
    
    @objc func screenTapped() {
        if firstName.isEditing || lastName.isEditing {
            if firstName.text != nil {
                first = firstName.text!
                firstName.resignFirstResponder()
                self.view.gestureRecognizers?.first!.isEnabled = false

            } else {
                firstName = nil
                firstName.resignFirstResponder()
                self.view.gestureRecognizers?.first!.isEnabled = false

            }
            if lastName.text != nil {
              last = lastName.text!
                lastName.resignFirstResponder()
                self.view.gestureRecognizers?.first!.isEnabled = false

            } else {
                lastName = nil
                lastName.resignFirstResponder()
                self.view.gestureRecognizers?.first!.isEnabled = false

            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isFreshLaunch == false {
            skipButton.setTitle("CANCEL", for: .normal)
            
        }
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
