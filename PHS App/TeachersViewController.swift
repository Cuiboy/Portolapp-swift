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
        var id = Int32()
        var first = String()
        var last = String()
        var subject1 = String()
    var subject2: String?
    var gender = Bool()
    
    

        if let data = try? String(contentsOf: URL(string: "https://spreadsheets.google.com/feeds/list/1LYh5MBpUI480rVDntpZOci3C78HdnMdeBRkjPGbsQl8/od6/public/basic?alt=json")!) {
            let jsonData = JSON(parseJSON: data)
            let entryArray = jsonData.dictionaryValue["feed"]!["entry"].arrayValue
            DispatchQueue.main.async {
                for entry in entryArray {
                    let teacherType = entry["content"]["$t"].stringValue
                    let finalJSON = teacherType.my_unquotedJSONFormatter(string: teacherType, rows: 6)
                    if finalJSON != "error" {
                        let teacherJSON = JSON(parseJSON: finalJSON)
                        let dictionary = teacherJSON.dictionaryObject!
                        if let idGet = dictionary["id"] as? String {
                            id = Int32(idGet)!
                        }
                        if let firstGet = dictionary["first"] as? String {
                            first = firstGet
                        }
                        if let lastGet = dictionary["last"] as? String {
                            last = lastGet
                        }
                        if let subject1Get = dictionary["subject1"] as? String {
                            subject1 = subject1Get
                        }
                        if let subject2Get = dictionary["subject2"] as? String {
                            if subject2Get == "nil" {
                                subject2 = nil
                            } else {
                                subject2 = subject2Get
                            }
                            if let genderGet = dictionary["gender"] as? String {
                                if genderGet == "f" {
                                    gender = true
                                } else {
                                    gender = false
                                }
                                
                            }
                        }
                        
                        let teachers = Teachers(context: PersistentService.context)
                        teachers.id = id
                        teachers.first = first
                        teachers.last = last
                        teachers.subject1 = subject1
                        teachers.subject2 = subject2
                        teachers.gender = gender
                        PersistentService.saveContext()
                        savedTeachers.append(teachers)
                        
                    }
                    
                }
                fetchedTeachersCount = entryArray.count
                
                }
            }
           
    
    }


        
func generateAlphaDict() {
    for teacher in savedTeachers {
        let key = "\(teacher.last![(teacher.last!.startIndex)])"
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
    for teacher in savedTeachers {
        if teacher.subject2 != nil {
           
            var key = teacher.subject1!
            var key2 = teacher.subject2!
            if key == "Spanish" || key == "French" || key == "Chinese" {
                key = "World Language"
            }   else if key == "Principal" || key == "Assistant Principal" || key == "Administrative Assistant" || key == "Lead Counselor" {
                adminDictionary[teacher] = key
                adminRows.append(teacher)
                key = "Administration"
            }
            if  key2 == "Spanish" || key2 == "French" || key2 == "Chinese" {
                key2 = "World Language"
            } else if key2 == "Principal" || key2 == "Assistant Principal" || key2 == "Administrative Assistnat" || key2 == "Lead Counselor" {
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
            var key = teacher.subject1!
            
            if key == "Spanish" || key == "French" || key == "Chinese" {
                key = "World Language"
            }   else if key == "Principal" || key == "Assistant Principal" || key == "Administrative Assistant" || key == "Lead Counselor" {
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
var teachersAlphaDict = [String: [Teachers]]()
var teachersAlphaSections = [String]()
var subjectsDictionary = [String: [Teachers]]()
var subjectsRows = [String]()
var adminDictionary = [Teachers: String]()
var adminRows = [Teachers]()
var savedCoaches = [Coaches]()
var coachesTeamDictionary = [String: [Coaches]]()
var coachesRows = [String]()

 var myClasses = [String?]()

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
    
    var myTeachers = [MyTeachers]()
   
    var classesToDisplay = [String?]()
    
    var allTeachersCount = Int()
    var allCoachesCount = Int()
   var displayCoaches = Bool()
    
    @IBOutlet weak var myTeachersTableView: UITableView!
    
    
    func fetchCoaches() {
        var first = String()
        var last = String()
        var email = String()
        var team1 = String()
        var team2: String?
        var gender = Bool()
        
        if let data = try? String(contentsOf: URL(string: "https://spreadsheets.google.com/feeds/list/14ewgMDTDGBDbNdlctcPWL_k4EiihCnwfJBhDyYLVqHc/od6/public/basic?alt=json")!) {
            let jsonData = JSON(parseJSON: data)
            let entryArray = jsonData.dictionaryValue["feed"]!["entry"].arrayValue
            DispatchQueue.main.async {
                let firstItem = entryArray[0]["content"]["$t"].stringValue
                if firstItem == "first: hold" {
                    self.displayCoaches = false
                } else {
                    self.displayCoaches = true
                    for i in 1 ... entryArray.count - 1 {
                        let teacherType = entryArray[i]["content"]["$t"].stringValue
                        let finalJSON = teacherType.my_unquotedJSONFormatter(string: teacherType, rows: 6)
                        if finalJSON != "error" {
                            let teacherJSON = JSON(parseJSON: finalJSON)
                            let dictionary = teacherJSON.dictionaryObject!
                            
                            if let firstGet = dictionary["first"] as? String {
                                first = firstGet
                            }
                            if let lastGet = dictionary["last"] as? String {
                                last = lastGet
                            }
                            if let emailGet = dictionary["email"] as? String {
                                email = emailGet
                            }
                            if let team1Get = dictionary["team1"] as? String {
                                team1 = team1Get
                            }
                            if let team2Get = dictionary["team2"] as? String {
                                if team2Get == "nil" {
                                    team2 = nil
                                } else {
                                    team2 = team2Get
                                }
                                if let genderGet = dictionary["gender"] as? String {
                                    if genderGet == "f" {
                                        gender = true
                                    } else {
                                        gender = false
                                    }
                                    
                                }
                            }
                            
                            let coaches = Coaches(context: PersistentService.context)
                            coaches.first = first
                            coaches.last = last
                            coaches.email = email
                            coaches.gender = gender
                            coaches.team1 = team1
                            coaches.team2 = team2
                            PersistentService.saveContext()
                            savedCoaches.append(coaches)
                        }
                        
                    }
                    fetchedCoachesCount = entryArray.count - 1
                }
                
            }
        }
    }
        

    func generateTeamsDict() {
        for coach in savedCoaches {
            let key = coach.team1!
            let upper = key.uppercased()
            if var coachTeam = coachesTeamDictionary[upper] {
                coachTeam.append(coach)
                coachesTeamDictionary[upper] = coachTeam
            } else {
                coachesTeamDictionary[upper] = [coach]
            }
            
            let key2 = coach.team2
            if key2 != nil {
                let upper = key2!.uppercased()
                if coachesTeamDictionary.keys.contains(upper) {
                    if var coachTeam2 = coachesTeamDictionary[upper] {
                        coachTeam2.append(coach)
                        coachesTeamDictionary[upper] = coachTeam2
                    }
                    
                }
            }
            
        }
        coachesRows = [String](coachesTeamDictionary.keys)

    }
    
    func loadSavedData() {
        let fetchRequest: NSFetchRequest<Teachers> = Teachers.fetchRequest()
        let sort = NSSortDescriptor(key: "last", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
           
            if savedTeachers.count > 0 {
                 let request = try PersistentService.context.fetch(fetchRequest)
                if request.count > 0 && request.count > savedTeachers.count {
                    for teachers in request {
                        if !savedTeachers.contains(teachers) {
                            PersistentService.context.delete(teachers)
                            PersistentService.saveContext()
                        }
                    }
                }
                
            }
            
            let newRequest = try PersistentService.context.fetch(fetchRequest)
            for detailRequest in newRequest {
                if detailRequest.subject1 == "History"  {
                    detailRequest.setValue("Social Studies", forKey: "subject1")
                }
                if detailRequest.subject2 == "History" {
                    detailRequest.setValue("Social Studies", forKey: "subject2")
                }
            }
            PersistentService.saveContext()
            
            let finalRequest = try PersistentService.context.fetch(fetchRequest)
            savedTeachers = finalRequest
           
            
            
            allTeachersCount = savedTeachers.count
            
                if fetchedTeachersCount > 0 && allTeachersCount > 0 {
                    if fetchedTeachersCount != allTeachersCount {
                        teachersAlphaDict.removeAll()
                        teachersAlphaSections.removeAll()
                        subjectsDictionary.removeAll()
                        subjectsRows.removeAll()
                        adminDictionary.removeAll()
                        adminRows.removeAll()
                        generateAlphaDict()
                        generateSubjectsDict()
                    }
                   
                } else if fetchedTeachersCount == 0 && allTeachersCount > 0 {
                    generateAlphaDict()
                    generateSubjectsDict()
                } else if fetchedTeachersCount == 0 && allCoachesCount == 0 {
                    if CheckInternet.Connection() {
                        DispatchQueue.global(qos: .background).async {
                            fetchTeachers()
                            DispatchQueue.main.async {
                                self.loadSavedData()
                                generateAlphaDict()
                                generateSubjectsDict()
                                self.reload()
                            }
                        }
                    } else {
                        let ac = UIAlertController(title: "No Internet Connection", message: "Could not load the list of teachers/coaches, make sure your device is connected to the Internet.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                        present(ac, animated: true)
                    }
            }
        } catch {
            print(error)
        }
    
    }
    
    func loadSavedCoachesData() {
        let fetchRequest: NSFetchRequest<Coaches> = Coaches.fetchRequest()
        do {
            if savedCoaches.count > 0 {
                //the fetch is already complete
                let request = try PersistentService.context.fetch(fetchRequest)
                if request.count > 0 && request.count > savedCoaches.count {
                    //something was deleted
                    for coach in request {
                        if savedCoaches.contains(coach) == false {
                            //delete the deleted object in core data
                            PersistentService.context.delete(coach)
                            PersistentService.saveContext()
                        }
                    }
                }
            }
            let newRequest = try PersistentService.context.fetch(fetchRequest)
            savedCoaches = newRequest
            allCoachesCount = savedCoaches.count
   
                if fetchedCoachesCount > 0 && allCoachesCount > 0 {
                    if fetchedCoachesCount != allCoachesCount {
                       coachesTeamDictionary.removeAll()
                        coachesRows.removeAll()
                        generateTeamsDict()
                        self.reload()
                    }
                } else if fetchedCoachesCount == 0 && allCoachesCount > 0 {
                    generateTeamsDict()
                } else if fetchedCoachesCount == 0 && allCoachesCount == 0 {
                    if CheckInternet.Connection() {
                        DispatchQueue.global(qos: .background).async {
                            self.fetchCoaches()
                            if self.displayCoaches {
                                DispatchQueue.main.async {
                                    self.loadSavedCoachesData()
                                    self.generateTeamsDict()
                                    self.reload()
                                    
                                }
                            }
                          
                        }

                    } else {
                        let ac = UIAlertController(title: "No Internet Connection", message: "Could not load the list of teachers/coaches, make sure your device is connected to the Internet.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                            present(ac, animated: true)
                    }
            }
        } catch {
            print(error)
        }
    }
    
   
    
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
        configrueTableViews()
        loadSavedData()
        loadSavedCoachesData()
        if CheckInternet.Connection() {
            DispatchQueue.global(qos: .background).async {
                fetchTeachers()
                self.fetchCoaches()
                DispatchQueue.main.async {
                    
                    self.loadSavedData()
                    self.loadSavedCoachesData()
                    
                }
            }
        }
        
        let fetchRequest: NSFetchRequest<MyTeachers> = MyTeachers.fetchRequest()
        do {
            let request = try PersistentService.context.fetch(fetchRequest)
            if request.count > 0 {
                navigationBar.topItem?.rightBarButtonItem = editButton
                for teacher in request {
                    print(teacher.teacher?.last ?? "nil")
                }
            } else {
                navigationBar.topItem?.rightBarButtonItem = nil
            }
            myTeachers = request
        } catch {
            
        }
        
        let classFetchRequest: NSFetchRequest<MyClasses> = MyClasses.fetchRequest()
        do {
          let request = try PersistentService.context.fetch(classFetchRequest)
            if request.count > 0 {
                let object = request.first!
                myClasses = [object.period1, object.period2, object.period3, object.period4, object.period5, object.period6, object.period7, object.period8]
                for i in 0...myClasses.count - 1 {
                    if myClasses[i] == "History"{
                        myClasses[i] = "Social Studies"
                    }
                }
             
                classesToDisplay = myClasses.filter { $0 != "Free Period" && $0 != "Sports" && $0 != "Sport" }
               
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
        
        if self.myTeachers.count == 0 {
            self.view.bringSubview(toFront: self.noTeachersView)
        } else {
            
            myTeachers = myTeachers.filter { $0.teacher != nil }
            self.view.bringSubview(toFront: self.myTeachersTableView)
        }
        
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
                    self.view.bringSubview(toFront: self.noTeachersView)
                } else {
                    self.view.bringSubview(toFront: self.myTeachersTableView)
                }
            case 1:
                self.view.bringSubview(toFront: self.allTableView)
            case 2:
                self.view.bringSubview(toFront: self.subjectsTableView)
            case 3:
                self.view.bringSubview(toFront: self.adminTableView)
            case 4:
                if self.displayCoaches {
                    self.view.bringSubview(toFront: self.coachesTableView)
                } else {
                    self.view.bringSubview(toFront: self.underConstructionView)
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
            return classesToDisplay.count
        }
      
        return 0
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AllTableViewControllerCellTableViewCell", owner: self, options: nil)?.first as! AllTableViewControllerCellTableViewCell
        if tableView == allTableView {
           
            let teacherKey = teachersAlphaSections[indexPath.section]
            if let teacherValues = teachersAlphaDict[teacherKey.uppercased()] {
                let teacher = teacherValues[indexPath.row]
                cell.first = teacher.first ?? ""
                cell.last = teacher.last ?? ""
                cell.gender = teacher.gender
                cell.name.text = "\(teacher.first?.uppercased() ?? "") \(teacher.last?.uppercased() ?? "")"
                cell.name.font = cell.name.font.withSize(CGFloat(16).relativeToWidth)
                if teacher.subject1 == "Visual and Performing Arts" {
                    teacher.subject1 = "VAPA"
                }
                if teacher.subject2 == "Visual and Performing Arts" {
                    teacher.subject2 = "VAPA"
                }
                if teacher.subject1 == "Principal" || teacher.subject1 == "Assistant Principal" || teacher.subject1 == "Administrative Assistant" || teacher.subject1 == "Lead Counselor" {
                    teacher.subject1 = "Admin"
                }
                if teacher.subject2 == "Principal" || teacher.subject2 == "Assistant Principal" || teacher.subject2 == "Administrative Assistant" || teacher.subject2 == "Lead Counselor" {
                    teacher.subject2 = "Admin"
                }
                if teacher.subject2 != nil {
                    cell.subject.text = "\(teacher.subject1?.uppercased() ?? "") & \(teacher.subject2?.uppercased() ?? "")"
                } else {
                    cell.subject.text = "\(teacher.subject1?.uppercased() ?? "")"
                }
                cell.subject.font = cell.subject.font.withSize(CGFloat(16).relativeToWidth.relativeToWidth)
                
                cell.initialsLabel.text = "\(Array(teacher.first!)[0])\(Array(teacher.last!)[0])"
                cell.initialsLabel.font = cell.initialsLabel.font.withSize(CGFloat(19).relativeToWidth)
                
                return cell
            }
        } else if tableView == adminTableView {
            let admin = adminRows[indexPath.row]
            let role = adminDictionary[adminRows[indexPath.row]]
            cell.first = admin.first!
            cell.last = admin.last!
            cell.gender = admin.gender
            cell.name.text = "\(admin.first?.uppercased() ?? "") \(admin.last?.uppercased() ?? "")"
            cell.name.font = cell.name.font.withSize(CGFloat(16).relativeToWidth)
            cell.initialsLabel.text = "\(Array(admin.first!)[0])\(Array(admin.last!)[0])"
            cell.initialsLabel.font = cell.initialsLabel.font.withSize(CGFloat(19).relativeToWidth)
            cell.subject.text = role
            return cell
        } else if tableView == myTeachersTableView {
            let myCell = Bundle.main.loadNibNamed("MyTeachersTableViewCell", owner: self, options: nil)?.first as! MyTeachersTableViewCell
            print(myTeachers.count, 100)
            print(myClasses.count, 101)
            print(classesToDisplay.count, 102)
            let myTeacher = myTeachers[indexPath.row]
            if myTeacher.teacher != nil {
                let period = myTeacher.period
                myCell.first = myTeacher.teacher!.first!
                myCell.last = myTeacher.teacher!.last!
                myCell.gender = myTeacher.teacher!.gender
                myCell.initialsLabel.text = "\(Array(myCell.first)[0])\(Array(myCell.last)[0])"
                myCell.teacherLabel.text = "\(myCell.first.uppercased()) \(myCell.last.uppercased())"
                if classesToDisplay[indexPath.row] == nil {
                    myCell.periodLabel.text = ""
                    myCell.classLabel.text = "PERIOD \(period)"
                } else {
                    myCell.periodLabel.text = "PERIOD \(period)"
                    myCell.classLabel.text = classesToDisplay[indexPath.row]
                }
                
          
                
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
                let newClasses = MyClasses(context: PersistentService.context)
                newClasses.period1 = vc.classes[0]
                newClasses.period2 = vc.classes[1]
                newClasses.period3 = vc.classes[2]
                newClasses.period4 = vc.classes[3]
                newClasses.period5 = vc.classes[4]
                newClasses.period6 = vc.classes[5]
                newClasses.period7 = vc.classes[6]
                newClasses.period8 = vc.classes[7]
                PersistentService.saveContext()
                for i in 0...7 {
                    myClasses.append(vc.classes[i])
                    let newTeacher = MyTeachers(context: PersistentService.context)
                    newTeacher.period = Int16(i.advanced(by: 1))
                    newTeacher.teacher = vc.myTeachers[i]
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
                
                let classesFetchrequest: NSFetchRequest<MyClasses> = MyClasses.fetchRequest()
                do {
                    let request = try PersistentService.context.fetch(classesFetchrequest)
                    let object = request.first!
                          object.setValue(vc.classes[0], forKey: "period1")
                          object.setValue(vc.classes[1], forKey: "period2")
                          object.setValue(vc.classes[2], forKey: "period3")
                          object.setValue(vc.classes[3], forKey: "period4")
                          object.setValue(vc.classes[4], forKey: "period5")
                          object.setValue(vc.classes[5], forKey: "period6")
                          object.setValue(vc.classes[6], forKey: "period7")
                          object.setValue(vc.classes[7], forKey: "period8")
                    PersistentService.saveContext()
                    
                } catch {
                    
                }
                
                
                
                let teacherFetchrequest: NSFetchRequest<MyTeachers> = MyTeachers.fetchRequest()
                var storedTeachers = [MyTeachers]()
                do {
                    let request = try PersistentService.context.fetch(teacherFetchrequest)
                    storedTeachers = request
                } catch {
                    
                    }
                
                for i in 0...7 {
                    myClasses.append(vc.classes[i])
                    storedTeachers[i].setValue(Int16(i + 1), forKey: "period")
                    storedTeachers[i].setValue(vc.myTeachers[i], forKey: "teacher")
                    PersistentService.saveContext()
                    
                }
            
               
            }
            
            fetchAndReload(withClasses: true)
            navigationBar.topItem?.rightBarButtonItem = editButton
            
        }
        
    }
    
    @IBAction func dismissToTeacherPage(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissToTeacherPage" {
            print("DISMISSED")
            if let vc = segue.source as? PickTeachersViewController {
                for i in 0...7 {
                    let mySchedule = MyTeachers(context: PersistentService.context)
                    mySchedule.period = Int16(i + 1)
                    mySchedule.teacher = vc.myTeachers[i]
                    PersistentService.saveContext()
                }
            }
    
            fetchAndReload(withClasses: false)
          
        }
       
    }
    
    func fetchAndReload(withClasses: Bool) {
        let teacherFetch: NSFetchRequest<MyTeachers> = MyTeachers.fetchRequest()
        do {
            let request = try PersistentService.context.fetch(teacherFetch)
            myTeachers = request
           
        } catch {
            
        }
        if withClasses {
            let classesFetch: NSFetchRequest<MyClasses> = MyClasses.fetchRequest()
            do {
                let request = try PersistentService.context.fetch(classesFetch)
                print(request.count)
                let object = request.first!
                myClasses = [object.period1, object.period2, object.period3, object.period4, object.period5, object.period6, object.period7, object.period8]
                
            } catch {
                
            }
        }
        
        print(myTeachers.count, "MYTEACHERS")
        print(myClasses.count, myClasses)
        print(classesToDisplay.count, classesToDisplay)
        
        
        myTeachers = myTeachers.filter { $0.teacher != nil }
        classesToDisplay = myClasses.filter {$0 != "Free Period" && $0 != "Sport" && $0 != "Sports"}
        
        view.bringSubview(toFront: myTeachersTableView)
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
                    
                    cell.first = teacher.first ?? ""
                    cell.last = teacher.last ?? ""
                    cell.gender = teacher.gender
                    cell.email = nil
                    cell.nameLabel.text = "\(teacher.first?.uppercased() ?? "") \(teacher.last?.uppercased() ?? "")"
                    cell.nameLabel.font = cell.nameLabel.font.withSize(CGFloat(16).relativeToWidth)
                    cell.initialsLabel.text = "\(Array(teacher.first!)[0])\(Array(teacher.last!)[0])"
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
