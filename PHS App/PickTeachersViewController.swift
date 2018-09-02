//
//  PickTeachersViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreData

class PickTeachersViewController: UIViewController {
    @IBOutlet weak var yourTeachers: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBAction func prevTapped(_ sender: Any) {
        if isFreshLaunch {
            let _ = navigationController?.popViewController(animated: true)
        } else {
            if isSecondScreen {
                dismiss(animated: true)
            }
        }
    }
    @IBOutlet weak var p1label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var p3Label: UILabel!
    @IBOutlet weak var p4Label: UILabel!
    @IBOutlet weak var p5Label: UILabel!
    @IBOutlet weak var p6Label: UILabel!
    @IBOutlet weak var p7Label: UILabel!
    @IBOutlet weak var p8Label: UILabel!
    @IBOutlet weak var p1Class: UILabel!
    @IBOutlet weak var p2Class: UILabel!
    @IBOutlet weak var p3Class: UILabel!
    @IBOutlet weak var p4Class: UILabel!
    @IBOutlet weak var p5Class: UILabel!
    @IBOutlet weak var p6Class: UILabel!
    @IBOutlet weak var p7Class: UILabel!
    @IBOutlet weak var p8Class: UILabel!
    @IBOutlet weak var p1TeacherLabel: UILabel!
    @IBOutlet weak var p2TeacherLabel: UILabel!
    @IBOutlet weak var p3TeacherLabel: UILabel!
    @IBOutlet weak var p4TeacherLabel: UILabel!
    @IBOutlet weak var p5TeacherLabel: UILabel!
    @IBOutlet weak var p6TeacherLabel: UILabel!
    @IBOutlet weak var p7TeacherLabel: UILabel!
    @IBOutlet weak var p8TeacherLabel: UILabel!
    
    @IBAction func p1Tapped(_ sender: Any) {
        period = 1
        buttonTapped(period: 1)
    }
    @IBAction func p2Tapped(_ sender: Any) {
        period = 2

        buttonTapped(period: 2)
    }
    @IBAction func p3Tapped(_ sender: Any) {
        period = 3

        buttonTapped(period: 3)
    }
    @IBAction func p4Tapped(_ sender: Any) {
        period = 4

        buttonTapped(period: 4)
    }
    @IBAction func p5Tapped(_ sender: Any) {
        period = 5

        buttonTapped(period: 5)
    }
    @IBAction func p6Tapped(_ sender: Any) {
        period = 6

        buttonTapped(period: 6)
    }
    @IBAction func p7Tapped(_ sender: Any) {
        period = 7

        buttonTapped(period: 7)
    }
    @IBAction func p8Tapped(_ sender: Any) {
        period = 8

        buttonTapped(period: 8)
    }
    
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p3Button: UIButton!
    @IBOutlet weak var p4Button: UIButton!
    @IBOutlet weak var p5Button: UIButton!
    @IBOutlet weak var p6Button: UIButton!
    @IBOutlet weak var p7Button: UIButton!
    @IBOutlet weak var p8Button: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var isPrevButtonHidden = false
    
    @IBAction func skipTapped(_ sender: Any) {
        if isFreshLaunch {
            let ac = UIAlertController(title: "Skip this page?", message: "Entering you teachers can make the app experience more personalized", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Stay", style: .cancel))
            ac.addAction(UIAlertAction(title: "Skip", style: .default, handler: { (_) in
                for i in 0...7 {
                    self.myTeachers[i] = nil
                    self.teacherLabels[i].text = "CLICK TO SELECT"
                }
                self.performSegue(withIdentifier: "skipToWelcome", sender: nil)
            }))
            
            present(ac, animated: true)
        } else {
            if isSecondScreen {
                for i in 0...7 {
                    self.myTeachers[i] = nil
                    self.teacherLabels[i].text = "CLICK TO SELECT"
                }
                self.performSegue(withIdentifier: "skipFromSecondScreen", sender: nil)
            } else {
                dismiss(animated: true)
            }
        }
     
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        var shouldPerformSegue = true
        for i in 0...7 {
            if buttons[i].isEnabled == true {
                if myTeachers[i] == nil {
                   let ac = UIAlertController(title: "Missing Fields", message: "Make sure you fill in all your teachers before continuing.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(ac, animated: true)
                    shouldPerformSegue = false
                } else {
                    continue
                }
            } else {
                continue
            }
        }
        if shouldPerformSegue {
            if isFreshLaunch {
                performSegue(withIdentifier: "finishToWelcome", sender: nil)

            } else {
                if  isPageEditing {
                    performSegue(withIdentifier: "unwindToTeacherPage", sender: nil)
                } else {
                    performSegue(withIdentifier: "newInfoSaved", sender: nil)
                }
            }
        }
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    func buttonTapped(period: Int) {
        if classes[period - 1] == nil {
            subject = "All"
        } else {
            let selectedClass = classes[period - 1]
            if subjects.contains(selectedClass!) {
                subject = selectedClass!
            } else if vapa.contains(selectedClass!) {
                    subject = "Visual and Performing Arts"
                } else if others.contains(selectedClass!) {
                    subject = "General Electives"
            } else if worldLanguage.contains(selectedClass!) {
                subject = "World Language"
            } else if rop.contains(selectedClass!) {
                subject = "ROP"
            } else {
                subject = "All"
            }
            
            }
        
        performSegue(withIdentifier: "pickTeacher", sender: nil)
        
    }
    let subjects = ["English", "Social Studies", "Math", "Physical Education", "Science", "Visual and Performing Arts", "World Language", "General Electives", "ROP", "Sport", "Free Period"]
    var classes = [String?]()
    var buttons = [UIButton]()
    var classLabels = [UILabel]()
    var teacherLabels = [UILabel]()
    var subject = String()
    var period = Int()
    
    var myTeachers = [Teachers?]()
    
    var isFreshLaunch = true
    var isSecondScreen = false
    var isPageEditing = false
    
    
    func makeArrays() {
        buttons.append(p1Button)
        buttons.append(p2Button)
        buttons.append(p3Button)
        buttons.append(p4Button)
        buttons.append(p5Button)
        buttons.append(p6Button)
        buttons.append(p7Button)
        buttons.append(p8Button)
        classLabels.append(p1Class)
         classLabels.append(p2Class)
         classLabels.append(p3Class)
         classLabels.append(p4Class)
         classLabels.append(p5Class)
         classLabels.append(p6Class)
         classLabels.append(p7Class)
         classLabels.append(p8Class)
        teacherLabels.append(p1TeacherLabel)
        teacherLabels.append(p2TeacherLabel)
        teacherLabels.append(p3TeacherLabel)
        teacherLabels.append(p4TeacherLabel)
        teacherLabels.append(p5TeacherLabel)
        teacherLabels.append(p6TeacherLabel)
        teacherLabels.append(p7TeacherLabel)
        teacherLabels.append(p8TeacherLabel)
        
        
    }
    
    func autoResizeUI() {
        prevButton.titleLabel!.font = prevButton.titleLabel!.font.withSize(CGFloat(15).relativeToWidth)
        yourTeachers.font = yourTeachers.font.withSize(CGFloat(22).relativeToWidth)
        for label in teacherLabels {
            label.font = label.font.withSize(CGFloat(22).relativeToWidth)
        }
        for label in classLabels {
            label.font = label.font.withSize(CGFloat(14).relativeToWidth)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeArrays()
        autoResizeUI()
        for i in 0...classLabels.count - 1 {
            if classes[i] == nil {
                classLabels[i].text = "PERIOD \(i + 1)"
            } else {
                classLabels[i].text = classes[i]!.uppercased()
                if classLabels[i].text == "SPORT" || classLabels[i].text == "FREE PERIOD" {
                    teacherLabels[i].text = "N/A"
                    buttons[i].isEnabled = false
                }
            }
            
        }
        for _ in 0...7 {
            myTeachers.append(nil)
        }
        if !isFreshLaunch {
            skipButton.titleLabel!.text = "CANCEL"
        }
        
        if isPrevButtonHidden {
            prevButton.isHidden = true
        } else {
            prevButton.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToTeachers(segue: UIStoryboardSegue) {
        if segue.identifier == "backToTeacher" {
            if let source = segue.source as? TeacherPickerViewController {
                let teacher = source.selectedItem
                myTeachers[period - 1] = teacher!
                let teacherLabel = "\(teacher!.first!) \(teacher!.last!)"
                teacherLabels[period - 1].text = teacherLabel.uppercased()
            }
                
            }
            
        }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickTeacher" {
            if let vc = segue.destination as? TeacherPickerViewController {
                switch subject {
                case "All", "General Electives", "ROP":
                    var preparedArray = [Teachers]()
                    for classSubjects in subjectsRows {
                        if classSubjects != "ADMINISTRATION" || classSubjects != "SUPPORT STAFF" || classSubjects != "SPECIAL EDUCATION" {
                            let subjectGroup = subjectsDictionary[classSubjects]
                            for teachers in subjectGroup! {
                                preparedArray.append(teachers)
                            }
                        }
                        
                    }
                    vc.teacherObjects = preparedArray
                case "English", "Social Studies", "Math", "Physical Education", "Science", "Visual and Performing Arts", "World Language", "History":
                    var preparedArray = [Teachers]()
                    let subjectGroup = subjectsDictionary[subject.uppercased()]
                    for teachers in subjectGroup! {
                       preparedArray.append(teachers)
                    }
                    vc.teacherObjects = preparedArray
                default:
                    var preparedArray = [Teachers]()
                    for classSubjects in subjectsRows {
                        if classSubjects != "ADMINISTRATION" || classSubjects != "SUPPORT STAFF" || classSubjects != "SPECIAL EDUCATION" {
                            let subjectGroup = subjectsDictionary[classSubjects]
                            for teachers in subjectGroup! {
                                preparedArray.append(teachers)
                            }
                        }
                        
                    }
                    vc.teacherObjects = preparedArray
                }
            }
          
        } else if segue.identifier == "skipToWelcome" {
            if !classes.contains(nil) {
                let myClasses = MyClasses(context: PersistentService.context)
                myClasses.period1 = classes[0]
                myClasses.period2 = classes[1]
                myClasses.period3 = classes[2]
                myClasses.period4 = classes[3]
                myClasses.period5 = classes[4]
                myClasses.period6 = classes[5]
                myClasses.period7 = classes[6]
                myClasses.period8 = classes[7]
                PersistentService.saveContext()
            }
         
      
        
        } else if segue.identifier == "finishToWelcome" {
            if !classes.contains(nil) {
                let myClasses = MyClasses(context: PersistentService.context)
                myClasses.period1 = classes[0]
                myClasses.period2 = classes[1]
                myClasses.period3 = classes[2]
                myClasses.period4 = classes[3]
                myClasses.period5 = classes[4]
                myClasses.period6 = classes[5]
                myClasses.period7 = classes[6]
                myClasses.period8 = classes[7]
                PersistentService.saveContext()
                
            }
     
            for i in 0...7 {
             let mySchedule = MyTeachers(context: PersistentService.context)
                mySchedule.period = Int16(i + 1)
                mySchedule.teacher = myTeachers[i]
                PersistentService.saveContext()
            }
           
            
        }
    }
    

}
