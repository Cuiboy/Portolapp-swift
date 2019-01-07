//
//  TeachersViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/13/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import Segmentio
import CoreData
import CoreGraphics
import ExpandableCell

 var fetchedTeachersCount = 0
var fetchedCoachesCount = 0


 func fetchTeachers() {
    print("CALLED FETCHED TEACEHRS")
    if let data = Bundle.main.path(forResource: "teachersInfo", ofType: "txt") {
        if let content = try? String(contentsOfFile: data) {
            if let jsonData = JSON(parseJSON: content).dictionaryValue["teachers"]?.arrayValue {
          
                for member in jsonData {
                    let detail = member.dictionaryObject!
                    let object = NewTeachers()
                    if let first = detail["first"] as? String {
                        object.first = first
                    }
                    if let last = detail["last"] as? String {
                        object.last = last
                    }
                    if let subject1 = detail["subject1"] as? String {
                        object.subject1 = subject1
                    }
                    if let subject2 = detail["subject2"] as? String {
                        object.subject2 = subject2
                    } else {
                        object.subject2 = nil
                    }
                    if let isFemale = detail["isFemale"] as? Bool {
                        object.isFemale = isFemale
                    }
                    localTeachers.append(object)
                }
           
            }
        }
    }
    
    localTeachers = uniq(source: localTeachers)
    
    
    }


        
func generateAlphaDict() {
    for teacher in localTeachers {
        let key = "\(teacher.last[(teacher.last.startIndex)])"
        let upper = key.uppercased()
        if var teacherInfo = teachersAlphaDict[upper] {
            teacherInfo.append(teacher)
            teachersAlphaDict[upper] = teacherInfo
        } else {
            teachersAlphaDict[upper] = [teacher]
        }
    }
    teachersAlphaSections = [String](teachersAlphaDict.keys)
    teachersAlphaSections = teachersAlphaSections.sorted()
}

func generateSubjectsDict() {
    for teacher in localTeachers {
        if teacher.subject2 != nil {
           
            var key = teacher.subject1
            var key2 = teacher.subject2!
            if key == "Spanish" || key == "French" || key == "Chinese" {
                key = "World Language"
            }   else if key == "Principal" || key == "Assistant Principal" || key == "Administrative Assistant" || key == "Lead Counselor" || key == "Athletic Director" {
                adminDictionary[teacher] = key
                adminRows.append(teacher)
                key = "Administration"
            }
            if  key2 == "Spanish" || key2 == "French" || key2 == "Chinese" {
                key2 = "World Language"
            } else if key2 == "Principal" || key2 == "Assistant Principal" || key2 == "Administrative Assistnat" || key2 == "Lead Counselor" || key2 == "Athletic Director" {
                adminDictionary[teacher] = key
                adminRows.append(teacher)
                key2 = "Administration"
            }
            let upper = key.uppercased()
            let upper2 = key2.uppercased()
            if var teacherSubject = subjectsDictionary[upper] {
                teacherSubject.append(teacher)
                subjectsDictionary[upper] = teacherSubject
            } else {
                subjectsDictionary[upper] = [teacher]
            }
            if var teacherSubject2 = subjectsDictionary[upper2] {
                teacherSubject2.append(teacher)
                subjectsDictionary[upper2] = teacherSubject2
            } else {
                subjectsDictionary[upper2] = [teacher]
            }
            
        } else {
            var key = teacher.subject1
            if key == "Spanish" || key == "French" || key == "Chinese" {
                key = "World Language"
            }   else if key == "Principal" || key == "Assistant Principal" || key == "Administrative Assistant" || key == "Lead Counselor" || key == "Athletic Director" {
                adminDictionary[teacher] = key
                adminRows.append(teacher)
                key = "Administration"
            }
            let upper = key.uppercased()
            if var teacherSubject = subjectsDictionary[upper] {
                teacherSubject.append(teacher)
                subjectsDictionary[upper] = teacherSubject
            } else {
                subjectsDictionary[upper] = [teacher]
            }
 
    }
    
    subjectsDictionary = subjectsDictionary.filter {$0.key != "ADMINISTRATION"}
    subjectsRows = subjectsRows.filter { $0 != "ADMINISTRATION" }
    subjectsRows = [String](subjectsDictionary.keys)
    subjectsRows = subjectsRows.sorted()
}
}

var savedTeachers = [Teachers]()
var localTeachers = [NewTeachers]()
var teachersAlphaDict = [String: [NewTeachers]]()
var teachersAlphaSections = [String]()
var subjectsDictionary = [String: [NewTeachers]]()
var subjectsRows = [String]()
var adminDictionary = [NewTeachers: String]()
var adminRows = [NewTeachers]()
var savedCoaches = [Coaches]()
var coachesTeamDictionary = [String: [Coaches]]()
var coachesRows = [String]()

 var myClasses = [String?]()
  var masterSchedule = [MySchedule]()

class TeachersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {


    var underConstructionView = UnderConstructionView()
    @IBOutlet var navigationBar: UINavigationBar!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "editClasses", sender: nil)
    }
    
    
    @IBOutlet weak var segmentioView: Segmentio!
    var content = [SegmentioItem]()
    
    @IBOutlet weak var allTableView:  UITableView!
    @IBOutlet weak var subjectsTableView: ExpandableTableView!
   
    @IBOutlet weak var adminTableView: UITableView!
    var coachesTableView = ExpandableTableView()
    
    @IBOutlet weak var noTeachersView: UIView!
    var fillTeachersButton = UIView()
    var fillInLabel = UILabel()
    
    var myTeachers = [MyNewTeachers]()
 
    var classesToDisplay = [String?]()
    var displaySchedule = [MySchedule]()
    var allTeachersCount = Int()
    var allCoachesCount = Int()
   var displayCoaches = Bool()
    
    @IBOutlet weak var myTeachersTableView: UITableView!
    
    
    func reload() {
        self.coachesTableView.reloadData()
        self.allTableView.reloadData()
        self.subjectsTableView.reloadData()
        self.adminTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        setSegmentedControl()
        if localTeachers.count == 0 {
            fetchTeachers()
        }
        configrueTableViews()
        if teachersAlphaDict.count == 0 {
            generateAlphaDict()

        }
        if subjectsDictionary.count == 0 {
            generateSubjectsDict()

        }
        
        let fetchRequest: NSFetchRequest<MyNewTeachers> = MyNewTeachers.fetchRequest()
        do {
            let request = try PersistentService.context.fetch(fetchRequest)
            if request.count > 0 {
                navigationBar.topItem?.rightBarButtonItem = editButton
                self.view.bringSubviewToFront(self.myTeachersTableView)
            } else {
                navigationBar.topItem?.rightBarButtonItem = nil
                self.view.bringSubviewToFront(self.noTeachersView)
            }
            myTeachers = request
        } catch {
            
        }
        
        let scheduleFetchRequest: NSFetchRequest<MySchedule> = MySchedule.fetchRequest()
        do {
          let request = try PersistentService.context.fetch(scheduleFetchRequest)
            if request.count > 0 {
                var scheduleArray = request
                scheduleArray.sort { $0.period < $1.period }
                masterSchedule = scheduleArray
                for entry in scheduleArray {
                    myClasses.append(entry.name)
                }
             
                classesToDisplay = myClasses.filter { $0 != "Free Period" && $0 != "Sports" && $0 != "Sport" }
                displaySchedule = masterSchedule.filter {$0.name != "Free Period" && $0.name != "Sports" && $0.name != "Sport" }
               
            } else {
                myClasses = []
                classesToDisplay = []
            }
            
           
        } catch {
            
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fillInTapped))
       gestureRecognizer.delegate = self
        fillTeachersButton.addGestureRecognizer(gestureRecognizer)
        
      
        segmentioView.selectedSegmentioIndex = 0
        
       
        
    }
    
    @objc func fillInTapped() {
                performSegue(withIdentifier: "fillClasses", sender: nil)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
      
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            switch segmentIndex {
          
            case 0:
                if self.myTeachers.count == 0 {
                    self.view.bringSubviewToFront(self.noTeachersView)
                } else {
                    self.view.bringSubviewToFront(self.myTeachersTableView)
                }
            case 1:
                self.view.bringSubviewToFront(self.allTableView)
            case 2:
                self.view.bringSubviewToFront(self.subjectsTableView)
            case 3:
                self.view.bringSubviewToFront(self.adminTableView)
            case 4:
                if self.displayCoaches {
                    self.view.bringSubviewToFront(self.coachesTableView)
                } else {
                    self.view.bringSubviewToFront(self.underConstructionView)
                }
            default:
                print("more coming")
            }
        }

    }
    

    func setSegmentedControl() {
        
        let position = SegmentioPosition.dynamic
        let indicator = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 1, color: .white)
        let horizontal = SegmentioHorizontalSeparatorOptions(type: SegmentioHorizontalSeparatorType.none)
        let vertical = SegmentioVerticalSeparatorOptions(ratio: 0.1, color: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0))
        segmentioView.selectedSegmentioIndex = 0
        let options = SegmentioOptions(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), segmentPosition: position, scrollEnabled: true, indicatorOptions: indicator, horizontalSeparatorOptions: horizontal, verticalSeparatorOptions: vertical, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 1, segmentStates: (
            defaultState: SegmentioState(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), titleFont: UIFont(name: "Lato-Bold", size: CGFloat(16).relativeToWidth)!, titleTextColor: UIColor.white.withAlphaComponent(0.5)),
            selectedState: SegmentioState(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), titleFont: UIFont(name: "Lato-Bold", size: CGFloat(16).relativeToWidth)!, titleTextColor: .white),
            highlightedState: SegmentioState(backgroundColor: UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0), titleFont: UIFont(name: "Lato-Bold", size: CGFloat(16).relativeToWidth)!, titleTextColor: .white)
            )
            ,animationDuration: 0.2)
        let myItem = SegmentioItem(title: "FOR YOU", image: nil)
        let allItem = SegmentioItem(title: "ALL", image: nil)
        let subjectsItem = SegmentioItem(title: "SUBJECTS", image: nil)
        let adminItem = SegmentioItem(title: "ADMIN", image: nil)
        content = [myItem, allItem, subjectsItem, adminItem]
        segmentioView.setup(content: content, style: .onlyLabel, options: options)
        
    }
    
    func configrueTableViews() {
       
        allTableView.delegate = self
        allTableView.dataSource = self
        subjectsTableView.expandableDelegate = self
        subjectsTableView.register(UINib(nibName: "SubjectsExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: SubjectsExpandableTableViewCell.ID)
        subjectsTableView.register(UINib(nibName: "SubjectsExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: SubjectsExpandedTableViewCell.ID)
        
        adminTableView.delegate = self
        adminTableView.dataSource = self
        
        
        coachesTableView.expandableDelegate = self
        coachesTableView.animation = .automatic
        coachesTableView.register(UINib(nibName: "SubjectsExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: SubjectsExpandableTableViewCell.ID)
        coachesTableView.register(UINib(nibName: "SubjectsExpandedTableViewCell", bundle: nil), forCellReuseIdentifier: SubjectsExpandedTableViewCell.ID)
        
        
   
        fillTeachersButton.frame = CGRect(x: 0, y: 0, width: CGFloat(250).relativeToWidth, height: CGFloat(50).relativeToWidth)
        fillTeachersButton.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height / 2 - CGFloat(100).relativeToWidth)
        fillTeachersButton.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
        fillTeachersButton.layer.cornerRadius = CGFloat(25).relativeToWidth
        fillInLabel.bounds = CGRect(x: 0, y: 0, width: fillTeachersButton.bounds.width, height: fillTeachersButton.bounds.height)
        fillInLabel.center = CGPoint(x: fillTeachersButton.bounds.width / 2, y: fillTeachersButton.bounds.height / 2)
        fillInLabel.text = "FILL IN YOUR SCHEDULE"
        fillInLabel.textAlignment = .center
        fillInLabel.font = UIFont(name: "Lato-Bold", size: CGFloat(17).relativeToWidth)
        fillInLabel.textColor = UIColor.white
        fillTeachersButton.addSubview(fillInLabel)
        fillTeachersButton.my_dropShadow()
        noTeachersView.addSubview(fillTeachersButton)
        
        myTeachersTableView.delegate = self
        myTeachersTableView.dataSource = self
        
        
    }
    
   
    

    

    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == allTableView {
           
             return teachersAlphaSections.count
        } else if tableView == adminTableView {
            return 1
        } else if tableView == myTeachersTableView {
            return 1
        }
       return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == allTableView {
            
            return teachersAlphaSections[section]
        }
        return nil
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == allTableView {
            return CGFloat(40).relativeToWidth
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == allTableView {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red:0.99, green:0.95, blue:1.00, alpha:1.0)
            let headerLabel = UILabel(frame: CGRect(x: CGFloat(30).relativeToWidth, y: CGFloat(5).relativeToWidth, width: allTableView.bounds.size.width, height: self.tableView(tableView, heightForHeaderInSection: section)))
            
            headerLabel.font = UIFont(name: "Lato-Bold", size: CGFloat(22).relativeToWidth)
            headerLabel.textColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
            headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            return headerView
        }
        return nil
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allTableView {
            let teacherKey = teachersAlphaSections[section]
            if let teacherValues = teachersAlphaDict[teacherKey] {
                return teacherValues.count
            }
        } else if tableView == adminTableView {
            return adminRows.count
        } else if tableView == myTeachersTableView {
            return displaySchedule.count
        }
      
        return 0
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AllTableViewControllerCellTableViewCell", owner: self, options: nil)?.first as! AllTableViewControllerCellTableViewCell
       
        if tableView == allTableView {
           
            let teacherKey = teachersAlphaSections[indexPath.section]
            
            if let teacherValues = teachersAlphaDict[teacherKey.uppercased()] {
                let teacher = teacherValues[indexPath.row]
                cell.first = teacher.first
                cell.last = teacher.last
                cell.gender = teacher.isFemale
                cell.name.text = "\(teacher.first.uppercased()) \(teacher.last.uppercased())"
                cell.name.font = cell.name.font.withSize(CGFloat(16).relativeToWidth)
                if teacher.subject2 != nil {
                    cell.subject.text = "\(teacher.subject1.uppercased()) & \(teacher.subject2!.uppercased())"
                } else {
                    cell.subject.text = "\(teacher.subject1.uppercased())"
                }
                cell.subject.font = cell.subject.font.withSize(CGFloat(16).relativeToWidth.relativeToWidth)
                cell.initialsLabel.text = "\(Array(teacher.first)[0])\(Array(teacher.last)[0])"
                cell.initialsLabel.font = cell.initialsLabel.font.withSize(CGFloat(19).relativeToWidth)
                
                return cell
            }
        } else if tableView == adminTableView {
            let admin = adminRows[indexPath.row]
            var role = String()
            if admin.subject1 == "Principal" || admin.subject1 == "Assistant Principal" || admin.subject1 == "Lead Counselor" || admin.subject1 == "Athletic Director" || admin.subject1 == "Administrative Assistant" {
                role = admin.subject1.uppercased()
            } else {
                role = (admin.subject2?.uppercased())!
            }
           
            cell.first = admin.first
            cell.last = admin.last
            cell.gender = admin.isFemale
            cell.name.text = "\(admin.first.uppercased()) \(admin.last.uppercased())"
            cell.name.font = cell.name.font.withSize(CGFloat(16).relativeToWidth)
            cell.initialsLabel.text = "\(Array(admin.first)[0])\(Array(admin.last)[0])"
            cell.initialsLabel.font = cell.initialsLabel.font.withSize(CGFloat(19).relativeToWidth)
            cell.subject.text = role
            return cell
        } else if tableView == myTeachersTableView {
            let myCell = Bundle.main.loadNibNamed("MyTeachersTableViewCell", owner: self, options: nil)?.first as! MyTeachersTableViewCell
            if displaySchedule.count != 0 {
                let schedule = displaySchedule[indexPath.row]
                
                myCell.first = schedule.teacher!.first!
                myCell.last = schedule.teacher!.last!
                myCell.gender = schedule.teacher!.isFemale
                myCell.initialsLabel.text = "\(Array(myCell.first)[0])\(Array(myCell.last)[0])"
                myCell.teacherLabel.text = "\(myCell.first.uppercased()) \(myCell.last.uppercased())"
                myCell.periodLabel.text = "PERIOD \(schedule.period)"
                myCell.classLabel.text = schedule.name!
            }
            
            
            
            return myCell
            
            }
            
            
        
      

        return UITableViewCell()
}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == myTeachersTableView {
            return CGFloat(80)
        }
        return CGFloat(70).relativeToWidth
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if tableView == allTableView {
            allTableView.sectionIndexColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
            return teachersAlphaSections
        }
        return nil
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fillClasses" {
            if let vc = segue.destination as? PickClassesViewController {
                vc.isFreshLaunch = false
                vc.isPrevButtonHidden = true
                
            }
        } else if segue.identifier == "editClasses" {
            if let vc = segue.destination as? PickClassesViewController {
                vc.isPageEditing = true
                vc.isFreshLaunch = false
                vc.isPrevButtonHidden = true
                vc.mySelectedTeachers = self.myTeachers
                vc.periods = myClasses
                
                
            }
        }
    }
    
    @IBAction func skipFromSecondScreen(segue: UIStoryboardSegue) {
        if segue.identifier == "skipFromSecondScreen" {
            print("skipped from second page")
        
        }
    }
    
    @IBAction func newInfoSaved(segue: UIStoryboardSegue) {
        if segue.identifier == "newInfoSaved" {
            if let vc = segue.source as? PickTeachersViewController {
           
                for i in 0...7 {
                    let newSchedule = MySchedule(context: PersistentService.context)
                    newSchedule.name = vc.classes[i]
                    newSchedule.period = Int16(i + 1)
                    let newTeacher = MyNewTeachers(context: PersistentService.context)
                    let currentTeacher = vc.myTeachers[i]
                    newTeacher.first = currentTeacher?.first
                    newTeacher.last = currentTeacher?.last
                    newTeacher.subject1 = currentTeacher?.subject1
                    newTeacher.subject2 = currentTeacher?.subject2
                    newTeacher.isFemale = currentTeacher?.isFemale ?? false
                    newSchedule.teacher = newTeacher
                    PersistentService.saveContext()
                }
            }
            fetchAndReload(withClasses: true)
            navigationBar.topItem?.rightBarButtonItem = editButton
        }
    }
    
    
    @IBAction func unwindToTeacherPage(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToTeacherPage" {
            if let vc = segue.source as? PickTeachersViewController {
                let scheduleFetchRequest: NSFetchRequest<MySchedule> = MySchedule.fetchRequest()
                let teacherFetchRequest: NSFetchRequest<MyNewTeachers> = MyNewTeachers.fetchRequest()
                do {
                    let request = try PersistentService.context.fetch(scheduleFetchRequest)
                    let teacherRequest = try PersistentService.context.fetch(teacherFetchRequest)
                    var requestSort = request
                    requestSort.sort {$0.period < $1.period}
                    for i in 0...7 {
                        let object = requestSort[i]
                        object.setValue(vc.classes[i], forKey: "name")
                        object.setValue(Int16(i + 1), forKey: "period")
                        let currentTeacher = vc.myTeachers[i]
                        let newTeacher = teacherRequest[i]
                        newTeacher.setValue(currentTeacher?.first, forKey: "first")
                        newTeacher.setValue(currentTeacher?.last, forKey: "last")
                        newTeacher.setValue(currentTeacher?.subject1, forKey: "subject1")
                        newTeacher.setValue(currentTeacher?.subject2, forKey: "subject2")
                        newTeacher.setValue(currentTeacher?.isFemale, forKey: "isFemale")
                        object.setValue(newTeacher, forKey: "teacher")
                        PersistentService.saveContext()
                    }
                } catch {
                    
                }

            
                
               
            }
            
            fetchAndReload(withClasses: true)
            navigationBar.topItem?.rightBarButtonItem = editButton
            
        }
        
    }
    
    
    func fetchAndReload(withClasses: Bool) {
        
        let scheduleFetch: NSFetchRequest<MySchedule> = MySchedule.fetchRequest()
        do {
            let request = try PersistentService.context.fetch(scheduleFetch)
            masterSchedule = request
            masterSchedule.sort { $0.period < $1.period }
            print(masterSchedule.count, "BUG HERE MAYBE?")
        } catch {
            
        }
        
        displaySchedule = masterSchedule.filter {$0.name != "Free Period" && $0.name != "Sports" && $0.name != "Sport" }
        
        view.bringSubviewToFront(myTeachersTableView)
       
        for item in displaySchedule {
            myTeachers.append(item.teacher!)
        }
        
        myTeachersTableView.reloadData()
       
    }
 
}




extension TeachersViewController: ExpandableDelegate {
     func numberOfSections(in expandableTableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        if expandableTableView == subjectsTableView {
            return subjectsRows.count

        } else if expandableTableView == coachesTableView {
            return coachesRows.count
        }
        return 1
    }
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        if expandableTableView == subjectsTableView {
            let department = subjectsRows[indexPath.row]
            var expandedArray = [SubjectsExpandedTableViewCell]()
            if let teachers = subjectsDictionary[department] {
                
                for teacher in teachers {
                    let cell = subjectsTableView.dequeueReusableCell(withIdentifier: SubjectsExpandedTableViewCell.ID) as! SubjectsExpandedTableViewCell
                    
                    cell.first = teacher.first
                    cell.last = teacher.last
                    cell.gender = teacher.isFemale
                    cell.email = nil
                    cell.nameLabel.text = "\(teacher.first.uppercased()) \(teacher.last.uppercased())"
                    cell.nameLabel.font = cell.nameLabel.font.withSize(CGFloat(16).relativeToWidth)
                    cell.initialsLabel.text = "\(Array(teacher.first)[0])\(Array(teacher.last)[0])"
                    cell.initialsLabel.font = cell.initialsLabel.font.withSize(CGFloat(16).relativeToWidth)
                    expandedArray.append(cell)
                }
                return expandedArray
            } else {
                return nil
            }
        } else if expandableTableView == coachesTableView {
            let team = coachesRows[indexPath.row]
            var expandedArray = [SubjectsExpandedTableViewCell]()
            if let coaches = coachesTeamDictionary[team] {
                for coach in coaches {
                    let cell = subjectsTableView.dequeueReusableCell(withIdentifier: SubjectsExpandedTableViewCell.ID) as! SubjectsExpandedTableViewCell
                    cell.first = coach.first ?? " "
                    cell.last = coach.last ?? " "
                    cell.email = coach.email
                    cell.gender = coach.gender
                    cell.nameLabel.text = "\(coach.first?.uppercased() ?? "") \(coach.last?.uppercased() ?? "")"
                    cell.nameLabel.font = cell.nameLabel.font.withSize(CGFloat(16).relativeToWidth)
                    cell.initialsLabel.text = "\(Array(coach.first!)[0])\(Array(coach.last!)[0])"
                    cell.initialsLabel.font = cell.initialsLabel.font.withSize(CGFloat(16).relativeToWidth)
                    expandedArray.append(cell)
                    
                }
                return expandedArray
            } else {
                return nil
            }
            
        }
      
        return nil
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
         var heightArray = [CGFloat]()
        if expandableTableView == subjectsTableView {
            if let teachers = self.expandableTableView(expandableTableView, expandedCellsForRowAt: indexPath){
                for _ in teachers {
                    heightArray.append(CGFloat(65).relativeToWidth)
                }
                return heightArray
            } else {
                return nil
            }
        } else if expandableTableView == coachesTableView {
            if let coaches = self.expandableTableView(expandableTableView, expandedCellsForRowAt: indexPath) {
                for _ in coaches {
                    heightArray.append(CGFloat(65).relativeToWidth)
                }
                return heightArray
            } else {
                return nil
            }
        }
        
        
        return nil
    }
    

    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(50).relativeToWidth
        
    }
    
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subjectsTableView.dequeueReusableCell(withIdentifier: SubjectsExpandableTableViewCell.ID) as! SubjectsExpandableTableViewCell

        if expandableTableView == subjectsTableView {
            cell.subjectLabel.text = subjectsRows[indexPath.row]
            cell.subjectLabel.font = cell.subjectLabel.font.withSize(CGFloat(20).relativeToWidth)
            return cell
        } else if expandableTableView == coachesTableView {
            cell.subjectLabel.text = coachesRows[indexPath.row]
            cell.subjectLabel.font = cell.subjectLabel.font.withSize(CGFloat(20).relativeToWidth)
            return cell

        }

        return cell
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
