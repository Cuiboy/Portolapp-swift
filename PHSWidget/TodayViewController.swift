//
//  TodayViewController.swift
//  PHSWidget
//
//  Created by Patrick Cui on 10/16/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import NotificationCenter

enum dayType {
    case today
    case tomorrow
    case nextMonday
    case custom
}
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
var today = Int()
var tomorrow = Int()
var nextMonday = Int()
    var specialDays = [SpecialDays]()
class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var endsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
   

    var day = Calendar.current.component(.day, from: Date())
    var minute = Calendar.current.component(.minute, from: Date())
    var timeOfDay: relativeTime?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeOfDay = Date().getRelativeTime()
        loadSpecialDays()
           getTodayType()
        configureTimeLeftLabel()
         Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view from its nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Date().isSchoolDay() {
            if Date().getRelativeTime() == relativeTime.during {
                fetchTimeLeft()
            }
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
        } else {
            print("no")
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
    

    @objc func update() {
        if Calendar.current.component(.day, from: Date()) != day {
            getTodayType()
            timeOfDay = Date().getRelativeTime()
            configureTimeLeftLabel()
          
            day = Calendar.current.component(.day, from: Date())
        } else {
            if timeOfDay != Date().getRelativeTime() {
                timeOfDay = Date().getRelativeTime()
                self.configureTimeLeftLabel()
               
            } else {
                if minute != Calendar.current.component(.minute, from: Date()) {
                    
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
  
    @objc func configureTimeLeftLabel() {
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
            self.timeLabel.text = text
       
        }
        
    }
    
    func loadEndsLabel(text: String) {
        DispatchQueue.main.async {
            self.endsLabel.text = text
       
        }
        
    }
    
    func loadMinutesLabel(text: String) {
        DispatchQueue.main.async {
            self.minutesLabel.text = text
          
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
         completionHandler(NCUpdateResult.newData)
       
    }
    
}
