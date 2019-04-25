//
//  HomeViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 7/22/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreGraphics
import UserNotifications

enum dayType {
    case today
    case tomorrow
    case nextMonday
    case custom
}

     var specialDays = [SpecialDays]()

    var today = Int()
    var tomorrow = Int()
    var nextMonday = Int()

func getDayType(date: Date) -> Int {
   
    var isSpecial = false
    for days in specialDays {
        if days.date.noon == date.noon {
            isSpecial = true
      
            return Int(days.type)
        }
    }
    if isSpecial == false {
        return 0
    }
    
}

func loadSpecialDays() {
    if let data = Bundle.main.path(forResource: "specialDays", ofType: "txt") {
        if let content = try? String(contentsOfFile: data) {
            
            if let jsonData = JSON(parseJSON: content).dictionaryValue["specialDays"]?.arrayValue {
                
                for days in jsonData {
                    
                    let detail = days.dictionaryObject!
                    let object = SpecialDays()
                    if let date = detail["date"] as? String {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/M/dd"
                        formatter.timeZone = Calendar.current.timeZone
                        formatter.locale = Calendar.current.locale
                        object.date = formatter.date(from: date)!
                    }
                    if let type = detail["case"] as? Int {
                        object.type = type
                    }
                    specialDays.append(object)
                }
            }
            
        }
    }
    
}

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var showMoreButton: UIButton!
    @IBAction func buttonTapped(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notif) in
            print(notif)
        })
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifDel) in
            
        }
        

    }
    
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var endsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
   
    var weekdayLabelView  = UIView()
    var barImage = UIView()
    var weekdayDots = UIView()
    var progressBar = UIView()
    var todayClassLabel = UIView()
    var day = Calendar.current.component(.day, from: Date())
    var minute = Calendar.current.component(.minute, from: Date())
    var timeOfDay: relativeTime?
    
    var schoolEvents = [SchoolEvents]()
    
    let joinButton = UIView()
    let joinLabel = UILabel()
    
    var deviceAnchor6 = Int()
    var deviceMax = Int()
    var eventTimes = [String]()
    var eventTitles = [String]()
    
    var isAppOpenedByUser = false
    var isAppConnected = false
    var fetchedNumber = Int()
    var savedEvents = [SavedEvents]()
    
    @IBOutlet weak var eventTime1: UILabel!
    @IBOutlet weak var eventTitle1: UILabel!
    @IBOutlet weak var eventTime2: UILabel!
    @IBOutlet weak var eventTitle2: UILabel!
    @IBOutlet weak var eventTime3: UILabel!
    @IBOutlet weak var eventTitle3: UILabel!
    @IBOutlet weak var gradient: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    var labels = [UILabel]()
    var views = [UIView]()
    var eventLabels = [UILabel]()
    
    let lastDay = Date(timeIntervalSince1970: 1559977200)
    let firstDay2019 = Date(timeIntervalSince1970: 1566457200)
    var dateDifference = Int()
    
    @objc func timeTapped() {
        timeLeftLabel.my_glowOnTap()
        minutesLabel.my_glowOnTap()
        endsLabel.my_glowOnTap()
    }
    @objc func event1Tapped() {
        eventTitle1.my_glowOnTap()
        eventTime1.my_glowOnTap()
    }
    @objc func event2Tapped() {
        eventTitle2.my_glowOnTap()
        eventTime2.my_glowOnTap()
    }
    @objc func event3Tapped() {
        eventTitle3.my_glowOnTap()
        eventTime3.my_glowOnTap()
    }
    
    func initialize() {
        deviceAnchor6 = Int(self.view.bounds.maxX / 6)
        deviceMax = Int(self.view.bounds.maxX)
        timeLeftLabel.my_dropShadow()
        endsLabel.my_dropShadow()
        minutesLabel.my_dropShadow()
        labels = [endsLabel, minutesLabel, timeLeftLabel, eventTime1, eventTime2, eventTime3, eventTitle1, eventTitle2, eventTitle3]
        views = [weekdayLabelView, weekdayDots, progressBar, barImage, todayClassLabel]
        eventLabels = [eventTime1, eventTime2, eventTime3, eventTitle1, eventTitle2, eventTitle3]
        
        for label in labels {
            label.alpha = 0
            label.font = label.font.withSize(label.font.pointSize.relativeToWidth)
            
        }
        for view in views {
            view.alpha = 0
        }
        for label in eventLabels {
        label.text = " "
        }
        let timeGesture = UITapGestureRecognizer(target: self, action: #selector(timeTapped))
        let event1Gesture = UITapGestureRecognizer(target: self, action: #selector(event1Tapped))
        let event2Gesture = UITapGestureRecognizer(target: self, action: #selector(event2Tapped))
        let event3Gesture = UITapGestureRecognizer(target: self, action: #selector(event3Tapped))
        timeGesture.delegate = self
        event1Gesture.delegate = self
        event2Gesture.delegate = self
        event3Gesture.delegate = self
        timeLeftLabel.addGestureRecognizer(timeGesture)
        eventTime1.addGestureRecognizer(event1Gesture)
        eventTitle1.addGestureRecognizer(event1Gesture)
        eventTime2.addGestureRecognizer(event2Gesture)
        eventTitle2.addGestureRecognizer(event2Gesture)
        eventTime3.addGestureRecognizer(event3Gesture)
        eventTitle3.addGestureRecognizer(event3Gesture)
        showMoreButton.titleLabel!.font = showMoreButton.titleLabel!.font.withSize(showMoreButton.titleLabel!.font.pointSize.relativeToWidth.relativeToWidth)
        showMoreButton.imageEdgeInsets.left = showMoreButton.imageEdgeInsets.left.relativeToWidth.relativeToWidth
        showMoreButton.isHidden = true
    }
  
    func fadeInViews(isAppOpened: Bool, completion: () -> ()) {
        DispatchQueue.main.async {
            self.timeOfDay = Date().timeOfSchoolDay()
            self.fetchEvents()
            self.configureWeekdays()
                if Date() >= Date.init(timeIntervalSince1970: 1552806000) {
            self.configureWeekdayDots()
            }
            self.configureProgressBar()
            self.configureBar()
            self.configureBarLabel(type: today)
            self.configureTimeLeftLabel()
        }
        completion()
    }
    
    func startAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self.weekdayLabelView.alpha = 1
                self.weekdayDots.alpha = 1
                self.joinButton.alpha = 1
            })
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self.progressBar.alpha = 1
                self.barImage.alpha = 1
                self.todayClassLabel.alpha = 1
                
            })
            
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self.eventTime1.alpha = 1
                self.eventTitle1.alpha = 1
                
            })
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self.eventTime2.alpha = 1
                self.eventTitle2.alpha = 1
                
            })
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self.eventTime3.alpha = 1
                self.eventTitle3.alpha = 1
                
            })
            UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                self.showMoreButton.alpha = 1
            })
            
        }
    }
    
    func userDefaults() {
        //first launch
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.performSegue(withIdentifier: "welcome", sender: nil)
        }
        
        //local notification patch
        let ifNotifUpdated = UserDefaults.standard.bool(forKey: "updateNotification")
        if !ifNotifUpdated {
            UserDefaults.standard.set(true, forKey: "notificationScheduled")
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (request) in
                if request.count > 0 {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            })
        }
        
        //teacher local migration notification
        let isTeacherUpdated = UserDefaults.standard.bool(forKey: "updateTeacher")
        if !isTeacherUpdated {
            UserDefaults.standard.set(true, forKey: "updateTeacher")
            let ac = UIAlertController(title: "Fill in your Schedule", message: "Over break, we have rebuilt the teachers page in order to optimize battery usage. As a result, we had to erase your saved classes and teachers. Head over to the teachers page to fill out your schedule again for a more personal experience.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //lay out UI
        initialize()
        

            //set-up
            isAppConnected = CheckInternet.Connection()
            loadSpecialDays()
            scheduleNotifications()
            getTodayType()
            DispatchQueue.global(qos: .background).async {
                //User Defaults
                self.userDefaults()
                self.fadeInViews(isAppOpened: self.isAppOpenedByUser, completion: {
                    self.startAnimation()
                })
            }
            
            
            
            //initilize timer
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
 
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        if Date().isSchoolDay() {
            if Date().getRelativeTime() == relativeTime.during {
                fetchTimeLeft()
            }
        }
      
            self.joinButton.backgroundColor = UIColor.clear
            self.joinLabel.textColor = UIColor.white
        
    }
    
    

    func scheduleLocal(on date: Date, with type: Int) {
        let notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                if date.isLongBreak == false {
                    var dateComponents = DateComponents()
                    dateComponents.year = Calendar.current.component(.year, from: notificationDate)
                    dateComponents.month = Calendar.current.component(.month, from: notificationDate)
                    dateComponents.day = Calendar.current.component(.day, from: notificationDate)
                    dateComponents.hour = 20
                    dateComponents.minute = 0
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let content = UNMutableNotificationContent()
                    content.title = "Schedule Reminder"
                    content.body = my_notificationPrompt(type: type)
                    content.sound = UNNotificationSound.default
                    
                    
                    let request = UNNotificationRequest(identifier: "\(date.noon)\(type)", content: content, trigger: trigger)
                    center.add(request)
                }
              
            } else {
               
            }
        }
    }

    

   
    
    func getTodayType() {
        today = 0
        tomorrow = 0
        nextMonday = 0
        for days in specialDays {
          
            if Date().noon == days.date.noon {
            
                today = days.type
               
            
            }
            if Date().tomorrow == days.date.noon {
                tomorrow = days.type
            
            }
            if Date().nextMonday().noon == days.date.noon {
                nextMonday = days.type
                
            }
        }
    
    }
    
    func scheduleNotifications() {
        var reducedSpecialDays = [SpecialDays]()
   
        reducedSpecialDays = specialDays.filter { $0.date > Date() }
        
        for days in reducedSpecialDays {
            scheduleLocal(on: days.date, with: days.type)
        }
        
        
    }
    
 
    
    @objc func update() {
        
        if isAppConnected == false {
            if CheckInternet.Connection() {
                updateWhenFirstConnected()
                isAppConnected = true
            }
        }
        //update only at midnight
        if Calendar.current.component(.day, from: Date()) != day {
            if Date() > lastDay && Date() < firstDay2019 {
                dateDifference = Calendar.current.dateComponents([.day], from: firstDay2019, to: Date()).day ?? 0
                loadTimeLeftLabel(text: String(dateDifference), size: CGFloat(140))
            } else {
                updateAtMidNight()
                day = Calendar.current.component(.day, from: Date())
            }
        } else {
            if Date() > lastDay && Date() < firstDay2019 {
                //nothing happens
            } else {
                if timeOfDay != Date().getRelativeTime() {
                    timeOfDay = Date().timeOfSchoolDay()
                    self.configureTimeLeftLabel()
                } else {
                    if minute != Calendar.current.component(.minute, from: Date()) {
                        if Date().isSchoolDay() {
                            
                            if timeOfDay == .during {
                                
                                loadProgressingBar(isInitial: false)
                            }
                        }
                        if Date().isSchoolDay() {
                            if timeOfDay == .during {
                                fetchTimeLeft()
                            }
                        }
                        minute = Calendar.current.component(.minute, from: Date())
                    }
                }
                
            }
            }
           
    }
    
  
  
    
    func updateWhenFirstConnected() {
        fetchEvents()
    }
    
    
    func updateAtMidNight() {
        
        eventTimes.removeAll()
        eventTitles.removeAll()
        savedEvents.removeAll()
        getTodayType()
        timeOfDay = Date().timeOfSchoolDay()
            configureTimeLeftLabel()
            for subview in weekdayDots.subviews {
                subview.removeFromSuperview()
            }
        if Date() >= Date.init(timeIntervalSince1970: 1552806000) {
            configureWeekdayDots()
        }
        
            progressBar.removeFromSuperview()
            configureProgressBar()
            progressBar.viewFadeIn()
            view.bringSubviewToFront(barImage)
            for subviews in todayClassLabel.subviews {
                subviews.removeFromSuperview()
            }
            configureBarLabel(type: today)
            fetchEvents()
 
    }

    @objc func joinTapped() {
        UIView.animate(withDuration: 0.3) {
          
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.joinButton.backgroundColor = UIColor.white
            self.joinLabel.textColor = UIColor(red: 0.702, green: 0.667, blue: 0.843, alpha: 1.00)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.5, animations: {
                self.joinButton.backgroundColor = UIColor.clear
                self.joinLabel.textColor = UIColor.white
            }, completion: nil)
        }
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "join") as? JoinViewController {
//            present(vc, animated: true)
//        }

        UIApplication.shared.open(URL(string: "https://www.eventbrite.com/e/the-addams-family-musical-tickets-57358504832")!, options: [:], completionHandler: nil)
    }
    
    
    func configureWeekdays() {
        if Date() < Date.init(timeIntervalSince1970: 1552806000) {
            joinButton.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width / 1.5, height: self.view.bounds.width / 6)
            joinButton.center = CGPoint(x: self.view.bounds.midX, y: self.minutesLabel.center.y + CGFloat(70).relativeToWidth)
            joinButton.layer.borderColor = UIColor.white.cgColor
            joinButton.layer.borderWidth = 2
            joinButton.layer.cornerRadius = joinButton.bounds.height / 2
            joinButton.clipsToBounds = true
            view.addSubview(joinButton)
            joinLabel.bounds = joinButton.bounds
            joinLabel.center = CGPoint(x: joinButton.bounds.width / 2, y: joinButton.bounds.height / 2)
            joinLabel.textAlignment = .center
            joinLabel.textColor = UIColor.white
            joinLabel.text = "BUY MUSICAL TICKETS"
            joinLabel.font = UIFont(name: "Lato-Regular", size: CGFloat(18).relativeToWidth)
            joinButton.addSubview(joinLabel)
            let joinGesture = UITapGestureRecognizer(target: self, action: #selector(joinTapped))
            joinGesture.delegate = self
            joinButton.addGestureRecognizer(joinGesture)
            joinButton.alpha = 0
            
        } else {
                    for i in 0...4 {
                        let weekdayLabels = ["M", "T", "W", "T", "F"]
                        let weekdayLabel = UILabel()
                        weekdayLabel.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
                        weekdayLabel.center = CGPoint(x: deviceAnchor6 + deviceAnchor6 * i, y: Int(self.view.bounds.midY) - Int(CGFloat(30).relativeToWidth))
                        weekdayLabel.textAlignment = .center
                        weekdayLabel.text = weekdayLabels[i]
                        weekdayLabel.font = UIFont(name: "Lato-Regular", size: CGFloat(17).relativeToWidth)
                        weekdayLabel.textColor = UIColor.white
                        weekdayLabel.my_dropShadow()
                        weekdayLabelView.addSubview(weekdayLabel)
            
                    }
                    view.addSubview(weekdayLabelView)
        }
  

    }

    func configureWeekdayDots() {
        for i in 0 ... 4 {
             drawDots(withFill: false, loopNumber: i)
        }
         let weekToday = Calendar.current.component(.weekday, from: Date())
        if weekToday == 1 {
            view.addSubview(weekdayDots)
        } else if weekToday == 6  || weekToday == 7 {
         for i in 0...4 {
         drawDots(withFill: true, loopNumber: i)
            view.addSubview(weekdayDots)
            }
         } else {
         for i in 0...(weekToday - 2) {
         drawDots(withFill: true, loopNumber: i)
            view.addSubview(weekdayDots)
         }

         }
        
    }

    func drawDots(withFill: Bool, loopNumber: Int) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
        let img = renderer.image {
            ctx in

            if withFill {
                ctx.cgContext.setFillColor(UIColor.white.cgColor)
            }

            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)

            ctx.cgContext.setLineWidth(2)
            let rectangle = CGRect(x: 2.5, y: 2.5, width: 25, height: 25)
            ctx.cgContext.addEllipse(in: rectangle)

            if withFill {
                ctx.cgContext.drawPath(using: .fillStroke)
            } else {
                ctx.cgContext.drawPath(using: .stroke)
            }

        }
        let image = UIImageView(image: img)
        image.center = CGPoint(x: deviceAnchor6 + deviceAnchor6 * loopNumber, y: Int(self.view.bounds.height * 0.41))
        image.my_dropShadow()

        weekdayDots.addSubview(image)
    }
    
    func configureBar() {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Int(CGFloat(270).barRelativeToWidth), height: Int(CGFloat(30).barRelativeToWidth)))
        let img = renderer.image {
            ctx in
            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
            ctx.cgContext.setLineWidth(2)
            let rectangle = CGRect(x: 2, y: 5, width: Int(CGFloat(266).barRelativeToWidth), height: Int(CGFloat(20).barRelativeToWidth))
            let roundedNumber = Int(CGFloat(20).barRelativeToWidth) / 2
            let rounded = CGPath.init(roundedRect: rectangle, cornerWidth: CGFloat(roundedNumber), cornerHeight: CGFloat(roundedNumber), transform: nil)
            ctx.cgContext.addPath(rounded)
                ctx.cgContext.drawPath(using: .stroke)
        }
        
        let image = UIImageView(image: img)
     
        image.center = CGPoint(x: Int(self.view.bounds.midX), y: Int(self.view.bounds.midY) + Int(CGFloat(20).barRelativeToWidth))
        image.my_dropShadow()
        barImage.addSubview(image)
        view.addSubview(barImage)
        view.bringSubviewToFront(barImage)
        
    }
    
    
   func configureProgressBar() {
        let midPointX = Int(self.view.bounds.midX)
        let midPointY = Int(self.view.bounds.midY)
       let barStartingPoint = Int(midPointX - Int(CGFloat(123).barRelativeToWidth))
        let progressBarY = midPointY + Int(CGFloat(20).barRelativeToWidth)
    
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = CGFloat(10).barRelativeToWidth
        progressBar.alpha = 0
    
            if Date().isSchoolDay() {
                switch timeOfDay! {
                case .before:
                    progressBar.center = CGPoint(x: barStartingPoint, y: progressBarY)
                     progressBar.bounds.size = CGSize(width: Int(CGFloat(20).barRelativeToWidth), height: Int(CGFloat(20).barRelativeToWidth))
                    progressBar.my_setGradientBackground(colorOne: UIColor(red:0.89, green:0.62, blue:0.99, alpha:1.0), colorTwo: UIColor.white, inBounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: Int(CGFloat(266).barRelativeToWidth), height: Int(CGFloat(20).barRelativeToWidth))))
                    view.addSubview(progressBar)
                case .during:
                    loadProgressingBar(isInitial: true)
                case .after:
                    progressBar.center = CGPoint(x: midPointX, y: progressBarY)
                    progressBar.bounds.size = CGSize(width: Int(CGFloat(266).barRelativeToWidth), height: Int(CGFloat(20).barRelativeToWidth))
                    progressBar.my_setGradientBackground(colorOne: UIColor(red:0.89, green:0.62, blue:0.99, alpha:1.0), colorTwo: UIColor.white, inBounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: Int(CGFloat(266).barRelativeToWidth), height: Int(CGFloat(20).barRelativeToWidth))))
                    view.addSubview(progressBar)
                    
                }
            } 
    }
    
    func loadProgressingBar(isInitial: Bool) {
        var numerator = CGFloat()
         let denominator = CGFloat(numOfMinAtSchool(type: today)!)
        var percentage = CGFloat()
        let midPointX = Int(self.view.bounds.midX)
        let midPointY = Int(self.view.bounds.midY)
        let barStartingPoint = Int(midPointX - Int(CGFloat(123).barRelativeToWidth))
        let bound = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat(266).barRelativeToWidth, height: CGFloat(20).barRelativeToWidth))
         progressBar.my_setGradientBackground(colorOne: UIColor(red:0.89, green:0.62, blue:0.99, alpha:1.0), colorTwo: UIColor.white, inBounds: bound)
        if isInitial {
            numerator = CGFloat(Date().localTime().minFromSchoolStart())
          
             percentage = numerator / denominator
           
            progressBar.center = CGPoint(x: (barStartingPoint) + Int(CGFloat(123).barRelativeToWidth * percentage), y: midPointY + Int(CGFloat(20).barRelativeToWidth))
            progressBar.bounds.size = CGSize(width: CGFloat(20) + (CGFloat(246).barRelativeToWidth * percentage), height: CGFloat(20).barRelativeToWidth)
            view.addSubview(progressBar)

            view.bringSubviewToFront(barImage)

        } else {
            numerator = CGFloat(Date().localTime().minFromSchoolStart())
            percentage = numerator / denominator
            UIView.animate(withDuration: 1.5) {
                self.progressBar.center = CGPoint(x: (barStartingPoint) + Int(CGFloat(123).barRelativeToWidth * percentage), y: midPointY + Int(CGFloat(20).barRelativeToWidth))
                self.progressBar.bounds.size = CGSize(width: CGFloat(20).barRelativeToWidth + (CGFloat(246).barRelativeToWidth * percentage), height: CGFloat(20).barRelativeToWidth)
            }
        }
      
    }
    
    func configureBarLabel(type: Int) {
        var classLabels = my_getPeriodsFromToday(type: type)
        let startingPosition = (deviceMax - Int(CGFloat(250).barRelativeToWidth)) / 2
        let endingPosition = startingPosition +  Int(CGFloat(250).barRelativeToWidth)
        var distance = Int()
        if classLabels.count > 1 {
             distance = (endingPosition - startingPosition) / ( classLabels.count - 1 )
            for i in 0...( classLabels.count - 1 ) {
                let classLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
                classLabel.center = CGPoint(x: startingPosition + distance * i, y: Int(self.view.bounds.midY) + Int(CGFloat(50).barRelativeToWidth))
                classLabel.textAlignment = .center
                classLabel.text = classLabels[i]
                classLabel.font = UIFont(name: "Lato-Regular", size: CGFloat(19).relativeToWidth)
                classLabel.textColor = UIColor.white
                classLabel.my_dropShadow()
                todayClassLabel.addSubview(classLabel)
                view.addSubview(todayClassLabel)
            }
        } else {
             distance = endingPosition - startingPosition
            let classLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(distance), height: 30))
            classLabel.center = CGPoint(x: (startingPosition + endingPosition) / 2, y: Int(self.view.bounds.midY) + Int(CGFloat(50).barRelativeToWidth))
            classLabel.textAlignment = .center
            classLabel.text = classLabels[0]
            
            classLabel.font = UIFont(name: "Lato-Regular", size: CGFloat(19).relativeToWidth)
            classLabel.textColor = UIColor.white
            classLabel.my_dropShadow()
            
            todayClassLabel.addSubview(classLabel)
            view.addSubview(todayClassLabel)
          
        }
    }
    
    
    @objc func fetchEvents() {
     
        if CheckInternet.Connection() {
            var date = Date()
            var time = String()
            var eventTitle = String()
            var notification = Bool()
            if let data = try? String(contentsOf: URL(string: "https://portola.epicteam.app/api/events")!) {
                let jsonData = JSON(parseJSON: data).dictionaryValue["events"]!
                
                let array = jsonData.arrayValue
                for events in array {
                    let dictionary = events.dictionaryObject!
                    if let dateGet = dictionary["date"] as? String {
                            print(dateGet)
                      
                            let formatter = DateFormatter()
                            formatter.timeZone = Calendar.current.timeZone
                            formatter.locale = Calendar.current.locale
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                            let UTCDate = formatter.date(from: dateGet) ?? Date.distantPast
                            let currentDate = Calendar.current.date(byAdding: .hour, value: -UTCDifference(), to: UTCDate) ?? Date.distantPast
                            date = currentDate
                        
                    } else {
                        date = Date.distantPast
                    }
                    if let timeGet = dictionary["time"] as? String {
                        time = timeGet
                    } else {
                        time = "N/A"
                    }
                    if let eventTitleGet = dictionary["title"] as? String {
                        eventTitle = eventTitleGet
                    } else {
                        eventTitle = "N/A"
                    }
                    if let notificationGet = dictionary["notify"] as? Bool {
                        notification = notificationGet
                    }
                    
                    let currentEvent = SchoolEvents()
                    currentEvent.date = date
                    currentEvent.time = time
                    currentEvent.title = eventTitle
                    currentEvent.notification = notification
                    schoolEvents.append(currentEvent)
                    
                }
            }
        } else {
            let ac = UIAlertController(title: "No Internet Connection", message: "Could not load any upcoming events because there is no Internet connection.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
       
        DispatchQueue.main.async {
            self.configureEvents()
        }
    }

    func configureEvents() {
        if schoolEvents.count > 0 {
            schoolEvents = schoolEvents.filter {
                $0.date.noon >= Date().noon
                
            }
            schoolEvents = schoolEvents.sorted(by: {$0.date < $1.date})
            for events in schoolEvents {
                if let dayAway = my_daysAwayFromToday(date: events.date.noon) {
                    if dayAway == 0 {
                        eventTimes.append("TODAY, \(events.time.uppercased())")
                    } else if dayAway == 1 {
                        eventTimes.append("TOMORROW, \(events.time.uppercased())")
                    } else if dayAway < 7 {
                        let weekday = getWeekdayString(date: events.date, isUpper: true)
                        eventTimes.append("\(weekday), \(events.time.uppercased())")
                    } else {
                        let day = Calendar.current.component(.day, from: events.date)
                        let month = Calendar.current.component(.month, from: events.date)
                        let dateString = "\(month)/\(day)"
                        eventTimes.append("\(dateString), \(events.time.uppercased())")
                    }
                }
                    eventTitles.append(events.title)
            }
        
        
            switch schoolEvents.count {
            case 1:
                self.eventTime1.text = eventTimes[0]
              
                self.eventTitle1.text = eventTitles[0]
             
            case 2:
                self.eventTime1.text = eventTimes[0]
                self.eventTime2.text = eventTimes[1]
                self.eventTitle1.text = eventTitles[0]
                self.eventTitle2.text = eventTitles[1]
                
            default:
                self.eventTime1.text = eventTimes[0]
                self.eventTime2.text = eventTimes[1]
                self.eventTime3.text = eventTimes[2]
                self.eventTitle1.text = eventTitles[0]
                self.eventTitle2.text = eventTitles[1]
                self.eventTitle3.text = eventTitles[2]
            }
    
           
           
        } else {
            self.eventTime2.text = "NO EVENTS LOADED"
        }
        
        
        
    
    }

    
    
    @objc func configureNextSchoolDayStart() {
       
            DispatchQueue.main.async {
                self.loadEndsLabel(text: "SCHOOL STARTS")
            }
            let startingDate = Date().noon
            var interval = 1
            var dayType = 20
            while dayType == 20 {
                let onDate = Calendar.current.date(byAdding: .day, value: interval, to: startingDate)!
                if onDate.isWeekend() {
                    dayType = 20
                } else {
                    dayType = getDayType(date: onDate)
                }
                
                interval += 1
                
                if dayType != 20 {
                    
                    //found a non-20 day
                    let currentDate = onDate.noon
                    let firstDayStartTime = uniq(source: my_getSchedule(type: dayType, date: currentDate)!).first!
                    
                    let time = timeStringFromDate(date: firstDayStartTime)
                    DispatchQueue.main.async {
                        self.loadTimeLeftLabel(text: time, size: CGFloat(140))
                    }
                    
                    if Calendar.current.dateComponents([.day], from: startingDate, to: currentDate).day == 1 {
                        DispatchQueue.main.async {
                            self.loadMinutesLabel(text: "TOMORROW")
                        }
                    } else if Calendar.current.dateComponents([.day], from: startingDate, to: currentDate).day! < 7  {
                        DispatchQueue.main.async {
                            self.loadMinutesLabel(text: getWeekdayString(date: currentDate, isUpper: true))
                        }
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "M/d"
                        let schoolStartsString = formatter.string(from: currentDate)
                        DispatchQueue.main.async {
                            self.loadMinutesLabel(text: "ON \(schoolStartsString)")
                        }
                    }
                }
            }
        
        
    }
    
    func loadTimeLeftLabel(text: String, size: CGFloat) {
        DispatchQueue.main.async {
            self.timeLeftLabel.text = text
            self.timeLeftLabel.font = UIFont(name: "Heebo-Light", size: size.relativeToWidth)
            self.timeLeftLabel.fadeIn()
        }
        
    }
    
    func loadEndsLabel(text: String) {
        DispatchQueue.main.async {
            self.endsLabel.text = text
            self.endsLabel.fadeIn()
        }
       
    }
    
    func loadMinutesLabel(text: String) {
        DispatchQueue.main.async {
            self.minutesLabel.text = text
            self.minutesLabel.fadeIn()
        }
    }
    
   @objc func configureTimeLeftLabel() {
    if Date() > lastDay && Date() < firstDay2019 {
        print("YES")
        loadEndsLabel(text: "SCHOOL STARTS IN")
        loadMinutesLabel(text: "DAYS")
        dateDifference = Calendar.current.dateComponents([.day], from: Date(), to: firstDay2019).day ?? 0
        loadTimeLeftLabel(text: String(dateDifference), size: CGFloat(140))
        
    } else {
        print("NO")
        if Date().isSchoolDay() {
            switch timeOfDay! {
                
            case .before:
                let startTime = uniq(source: my_getSchedule(type: today, date: nil)!).first!
                loadTimeLeftLabel(text: timeStringFromDate(date: startTime), size: CGFloat(140))
                loadEndsLabel(text: "SCHOOL STARTS")
                loadMinutesLabel(text: "TODAY")
            case .during:
                
                fetchTimeLeft()
            case .after:
                if tomorrow == 20 {
                    
                    performSelector(inBackground: #selector(configureNextSchoolDayStart), with: nil)
                } else {
                    if Calendar.current.component(.weekday, from: Date()) == 6 {
                        if nextMonday == 20 {
                            
                            performSelector(inBackground: #selector(configureNextSchoolDayStart), with: nil)
                        } else {
                            let startTime = uniq(source: my_getSchedule(type: nextMonday, date: Date().nextMonday())!).first!
                            loadTimeLeftLabel(text: timeStringFromDate(date: startTime), size: CGFloat(140))
                            loadEndsLabel(text: "SCHOOL STARTS")
                            loadMinutesLabel(text: "MONDAY")
                        }
                        
                    } else {
                        let startTime = uniq(source: my_getSchedule(type: tomorrow, date: Date().tomorrow)!).first!
                        
                        loadTimeLeftLabel(text: timeStringFromDate(date: startTime), size: CGFloat(140))
                        loadEndsLabel(text: "SCHOOL STARTS")
                        loadMinutesLabel(text: "TOMORROW")
                    }
                }
                
                
            }
            
            
        } else {
            if Date().isWeekend() {
                if nextMonday == 20 {
                    
                    performSelector(inBackground: #selector(configureNextSchoolDayStart), with: nil)
                } else {
                    
                    let mondayStartTime = uniq(source: my_getSchedule(type: nextMonday, date: Date().nextMonday())!).first!
                    
                    loadTimeLeftLabel(text: timeStringFromDate(date: mondayStartTime), size: 140)
                    loadEndsLabel(text: "SCHOOL STARTS")
                    
                    switch Calendar.current.component(.weekday, from: Date()) {
                    case 7:
                        loadMinutesLabel(text: "MONDAY")
                    case 1:
                        loadMinutesLabel(text: "TOMORROW")
                    default:
                        loadMinutesLabel(text: "MONDAY")
                    }
                }
            } else {
                
                performSelector(inBackground: #selector(configureNextSchoolDayStart), with: nil)
                
            }
        }
    }
    
        
       
    }

    
    @objc func fetchTimeLeft() {
        var label = String()
        var end = String()
        if let newSchedule = my_getSchedule(type: today, date: nil) {
            let schedule = uniq(source: newSchedule)
            for i in 0...schedule.count - 1 {
              
                if schedule[i] >= Date().localTime() {
                    if let minutes = Calendar.current.dateComponents([.minute], from: Date().localTime(), to: schedule[i]).minute {
                        if minutes == 0 {
                            loadTimeLeftLabel(text: "<1", size: 160)
                            loadMinutesLabel(text: "MINUTE")
                        } else if minutes == 1 {
                            loadTimeLeftLabel(text: String(minutes), size: 160)
                            loadMinutesLabel(text: "MINUTE")
                        } else {
                            loadTimeLeftLabel(text: String(minutes), size: 160)
                            loadMinutesLabel(text: "MINUTES")
                        }
                        
                            if let rawLabel = my_getStartEndPeriodLabel(type: today) {
                                let rawLabelNumber = rawLabel[i - 1]
                                label = rawLabelNumber.getPeriodLabel()
                                if let startEndLabel = my_getStartEndLabel(type: today) {
                                    let isStart = startEndLabel[i - 1]
                                    end = isStart.startEndLabelFromBool()
                                    loadEndsLabel(text: "\(label) \(end) IN")
                                 
                                    break
                            }
                        }
                    }

                }
               
            }
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
