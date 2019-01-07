//
//  PickClassesViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreData

class PickClassesViewController: UIViewController {
    @IBOutlet weak var prevButton: UIButton!
    @IBAction func prevTapped(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var yourClasses: UILabel!
    @IBOutlet weak var p1Label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var p3Label: UILabel!
    @IBOutlet weak var p4Label: UILabel!
    @IBOutlet weak var p5Label: UILabel!
    @IBOutlet weak var p6Label: UILabel!
    @IBOutlet weak var p7Label: UILabel!
    @IBOutlet weak var p8Label: UILabel!
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p3Button: UIButton!
    @IBOutlet weak var p4Button: UIButton!
    @IBOutlet weak var p5Button: UIButton!
    @IBOutlet weak var p6Button: UIButton!
    @IBOutlet weak var p7Button: UIButton!
    @IBOutlet weak var p8Button: UIButton!
   
    @IBOutlet weak var p1ClassLabel: UILabel!
    @IBOutlet weak var p2ClassLabel: UILabel!
    @IBOutlet weak var p3ClassLabel: UILabel!
    @IBOutlet weak var p4ClassLabel: UILabel!
    @IBOutlet weak var p5ClassLabel: UILabel!
    @IBOutlet weak var p6ClassLabel: UILabel!
    @IBOutlet weak var p7ClassLabel: UILabel!
    @IBOutlet weak var p8ClassLabel: UILabel!
    @IBAction func p1ButtonTapped(_ sender: Any) {
        period = 1
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p2ButtonTapped(_ sender: Any) {
        period = 2
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p3ButtonTapped(_ sender: Any) {
        period = 3
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p4ButtonTapped(_ sender: Any) {
        period = 4
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p5ButtonTapped(_ sender: Any) {
        period = 5
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p6ButtonTapped(_ sender: Any) {
        period = 6
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p7ButtonTapped(_ sender: Any) {
        period =  7
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBAction func p8ButtonTapped(_ sender: Any) {
        period = 8
        performSegue(withIdentifier: "pickClass", sender: nil)

    }
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func skipTapped(_ sender: Any) {
        if isFreshLaunch {
            let ac = UIAlertController(title: "Skip this page?", message: "Entering your classes can make the app experiences more personalized.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Skip", style: .default, handler: { (_) in
                for label in self.classLabels {
                    label.text = "SELECT CLASS"
                }
                self.performSegue(withIdentifier: "classSkipped", sender: nil)
            }))
            ac.addAction(UIAlertAction(title: "Stay", style: .cancel))
            present(ac, animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        if periods.contains(nil) {
            let ac = UIAlertController(title: "Missing Classes", message: "Make sure you fill in all your classes before continuing.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
        } else {
            if isFreshLaunch {
                self.performSegue(withIdentifier: "nextToTeacher", sender: nil)
            } else {
                if isPageEditing {
                    self.performSegue(withIdentifier: "editToTeacher", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "classToTeacher", sender: nil)
                }
            }
        }
    }
    
    
    
    var isFreshLaunch = true
    var isPrevButtonHidden = false
    var isPageEditing = false
    var mySelectedTeachers = [MyNewTeachers]()
    var myClasses = [String?]()
    
    
    var buttons = [UIButton]()
    var labels = [UILabel]()
    var classLabels = [UILabel]()
  
    var periods = [String?]()
 
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    func autoResizeUI() {
        prevButton.titleLabel!.font = prevButton.titleLabel!.font.withSize(CGFloat(15).relativeToWidth)
        yourClasses.font = yourClasses.font.withSize(CGFloat(25).relativeToWidth)
        for label in labels {
            label.font = label.font.withSize(CGFloat(25).relativeToWidth)
        }
        for label in classLabels {
            label.font = label.font.withSize(CGFloat(24).relativeToWidth)
        }

    }
    
    
    var period = Int()
   
    
    func createArrays() {
       
        buttons.append(p1Button)
        buttons.append(p2Button)
        buttons.append(p3Button)
        buttons.append(p4Button)
        buttons.append(p5Button)
        buttons.append(p6Button)
        buttons.append(p7Button)
        buttons.append(p8Button)
        labels.append(p1Label)
        labels.append(p2Label)
        labels.append(p3Label)
        labels.append(p4Label)
        labels.append(p5Label)
        labels.append(p6Label)
        labels.append(p7Label)
        labels.append(p8Label)
        classLabels.append(p1ClassLabel)
        classLabels.append(p2ClassLabel)
        classLabels.append(p3ClassLabel)
        classLabels.append(p4ClassLabel)
        classLabels.append(p5ClassLabel)
        classLabels.append(p6ClassLabel)
        classLabels.append(p7ClassLabel)
        classLabels.append(p8ClassLabel)
        if !isPageEditing {
            for _ in 0...7 {
                periods.append(nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createArrays()
        autoResizeUI()
        if isPrevButtonHidden {
            prevButton.isHidden = true
        } else {
            prevButton.isHidden = false
        }
        if isPageEditing {
            let scheduleFetchRequest: NSFetchRequest<MySchedule> = MySchedule.fetchRequest()
            do {
                var request = try PersistentService.context.fetch(scheduleFetchRequest)
                request.sort {$0.period < $1.period}
                print(request.count, "READ HERE")
                for i in 0...7 {
                    classLabels[i].text = request[i].name?.uppercased()
                }
            } catch {
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !isFreshLaunch  {
            skipButton.setTitle("CANCEL", for: .normal)
           
        }
    }


    
    @IBAction func unwindToClass(segue: UIStoryboardSegue) {
        if segue.identifier == "backToClass" {
            let source = segue.source as? PickerViewController
            if source!.selectedItem != nil {
                let label = classLabels[period - 1]
                   label.text = source!.selectedItem?.uppercased()
                periods[period - 1] = source!.selectedItem
           
            }
            
        } else if segue.identifier == "detailBackToClass" {
            let source = segue.source as? DetailPickerViewController
            if source!.selectedItem != nil {
                let label = classLabels[period - 1]
                label.text = source!.selectedItem?.uppercased()
                periods[period - 1] = source!.selectedItem
                
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "skipToTeacher" {
            if let vc = segue.destination as? PickTeachersViewController {
                for _ in 0...7 {
                    vc.classes.append(nil)
                }
            }
            
        } else if segue.identifier == "nextToTeacher" {
            if let vc = segue.destination as? PickTeachersViewController {
                vc.classes = periods
            }
        } else if segue.identifier == "classToTeacher" {
            if let vc = segue.destination as? PickTeachersViewController {
                vc.classes = periods
                vc.isFreshLaunch = false
                vc.isSecondScreen = true
            }
        } else if segue.identifier == "editToTeacher" {
            if let vc = segue.destination as? PickTeachersViewController {
                vc.classes = periods
                vc.isPageEditing = true
                vc.isFreshLaunch = false
                vc.isSecondScreen = true
            }
        }
        
    }
   
 

}
