//
//  BellScheduleViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 9/25/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreGraphics

class BellScheduleViewController: UIViewController {
    
    var classesRaw = [Int]()
    var bellSchedule = [Date]()
    var classesString = [String]()
    var classesLabels = [UILabel]()
    var timeLabels = [UILabel]()
    
    var progressView = UIView()
    var progress = UIView()
    var day = Calendar.current.component(.day, from: Date())
    var min = Calendar.current.component(.minute, from: Date())
    
    var minimum = CGFloat()
    var maximum =  CGFloat()
    var diff = CGFloat()
    var minOfSchool = numOfMinAtSchool(type: today)
    var minSinceSchool = Date().localTime().minFromSchoolStart()
    var percentage = CGFloat()
    
    let noSchoolLabel = UILabel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initilize()
        
        drawProgressLine()
        configureTime()
        configureHoliday()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    
    @objc func update() {
        if Calendar.current.component(.day, from: Date()) != day {
            day = Calendar.current.component(.day, from: Date())
            
            purge()
            initilize()
            configureTime()
            configureHoliday()
            if today == 20 || !Date().isSchoolDay() {
                if progressView.isHidden == false {
                    progressView.isHidden = true
                }
            } else {
                if progressView.isHidden == true {
                    progressView.isHidden = false
                }
            }
        } else if Calendar.current.component(.minute, from: Date()) != min {
            
            configureTime()
            min = Calendar.current.component(.minute, from: Date())
        }
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        progressView.layer.cornerRadius = progressView.bounds.width / 2
        progress.layer.cornerRadius = progress.bounds.height / 2
        configureLabels()
    }
    
    func initilize() {
        if today != 20 && Date().noon.isSchoolDay() {
            for i in 0...my_getSchedule(type: today, date: nil)!.count - 1 {
                if i % 2 == 0 {
                    bellSchedule.append(my_getSchedule(type: today, date: nil)![i])
                }
            }
           
        }
        
        
        if let todayRaw = my_getStartEndPeriodLabel(type: today) {
            for i in 0...todayRaw.count - 1 {
                var prev: Int?
                if i > 0 {
                    prev = todayRaw[i - 1]
                } else {
                    prev = nil
                }
                if prev != nil {
                    if todayRaw[i] != prev {
                        classesRaw.append(todayRaw[i])
                    }
                } else {
                    classesRaw.append(todayRaw[i])
                }
            }
          
        }
        
        for classes in classesRaw {
            classesString.append(classes.getPeriodLabel().lowercased().capitalizingFirstLetter())
        }
        
        
        if today != 20 && Date().isSchoolDay() {
            percentage = CGFloat(minSinceSchool) / CGFloat(minOfSchool!)
        } else {
            percentage = 0
        }

    }
    
    func drawProgressLine() {
        if today == 20 {
            return
        } else if !Date().isSchoolDay() {
            return
        }
        progressView.bounds = CGRect(x: 0, y: 0, width: CGFloat(40).relativeToWidth, height: CGFloat(500).relativeToWidth)
        progressView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY - CGFloat(30).relativeToWidth)
        progressView.clipsToBounds = true
        progressView.layer.borderWidth = 3
        progressView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(progressView)
        progress.bounds = CGRect(x: 0, y: 0, width: CGFloat(35).relativeToWidth, height: CGFloat(35).relativeToWidth)
        progress.layer.borderWidth = 2.5
        progress.layer.borderColor = UIColor.white.cgColor
        progress.clipsToBounds = true
        progress.my_setGradientBackground(colorOne: UIColor(red:0.89, green:0.62, blue:0.99, alpha:1.0), colorTwo: UIColor.white, inBounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: Int(CGFloat(35).barRelativeToWidth), height: Int(CGFloat(35).barRelativeToWidth))))
        progressView.addSubview(progress)
        
    }
    
    func configureTime() {
        minimum = progressView.bounds.minY + CGFloat(progress.bounds.height.relativeToWidth / 2)
        maximum =  progressView.bounds.maxY - CGFloat(progress.bounds.height.relativeToWidth / 2)
        diff = maximum - minimum
        minOfSchool = numOfMinAtSchool(type: today)
        minSinceSchool = Date().localTime().minFromSchoolStart()
        if today == 20 {
            return
        } else if !Date().isSchoolDay() {
            return
        }
        
        
     
        if Date().getRelativeTime() != nil {
            switch Date().getRelativeTime()! {
            case relativeTime.before:
                progress.center = CGPoint(x: progressView.bounds.midX, y: minimum)
            case relativeTime.during:
                self.progress.center = CGPoint(x: self.progressView.bounds.midX, y: minimum + diff * percentage)
                updateTime()

            case relativeTime.after:
                progress.center = CGPoint(x: progressView.bounds.midX, y: maximum)

            }
        }
       
    }
    
    func updateTime() {
        minimum = progressView.bounds.minY + CGFloat(progress.bounds.height.relativeToWidth / 2)
        maximum =  progressView.bounds.maxY - CGFloat(progress.bounds.height.relativeToWidth / 2)
        diff = maximum - minimum
        minOfSchool = numOfMinAtSchool(type: today)
        minSinceSchool = Date().localTime().minFromSchoolStart()
        percentage = CGFloat(minSinceSchool) / CGFloat(minOfSchool!)
        UIView.animate(withDuration: 1.5) {
            self.progress.center = CGPoint(x: self.progressView.bounds.midX, y: self.minimum + self.diff * self.percentage)
        }
       
    }
    
    func configureLabels() {
        print(bellSchedule)
        print(classesString)
        guard bellSchedule.count == classesString.count else {return}
        bellSchedule.append(my_getStartEndTimeFromToday(type: today, dayType: dayType.today, date: nil)[1])
        classesString.append("End Time")
        let top = progressView.frame.minY
        let bottom = progressView.frame.maxY
//        let left = progressView.bounds.minX
//        let right = progressView.bounds.maxX
  print(top, bottom)
        let scaleFactor = CGFloat((bellSchedule.count * 2) - 1)
        for i in 0...classesString.count - 1 {
            let label = UILabel()
            label.bounds = CGRect(x: 0, y: 0, width: (progressView.center.x - progressView.frame.width / 2) - CGFloat(30).relativeToWidth, height: (bottom - top) / scaleFactor)
            label.center = CGPoint(x: (progressView.center.x - progressView.frame.width / 2) / 2, y: CGFloat(scaleFactor / 2) + top + (bottom - top) * CGFloat(2 * i) / scaleFactor)
            label.text = classesString[i].uppercased()
            label.textAlignment = .right
            label.textColor = UIColor.white
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.7

            label.font = UIFont(name: "Lato-Light", size: CGFloat(18).relativeToWidth)
            classesLabels.append(label)
            view.addSubview(label)
            
        }
        for i in 0...bellSchedule.count - 1 {
            let label = UILabel()
            label.bounds = CGRect(x: 0, y: 0, width: (progressView.center.x - progressView.frame.width / 2) - CGFloat(30).relativeToWidth, height: (bottom - top) / scaleFactor)
            label.center = CGPoint(x: self.view.bounds.width - (progressView.center.x - progressView.frame.width / 2) / 2, y: CGFloat(scaleFactor / 2) + top + (bottom - top) * CGFloat(2 * i) / scaleFactor)
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            label.text = formatter.string(from: bellSchedule[i])
            label.textAlignment = .left
            label.textColor = UIColor.white
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
         
            label.font = UIFont(name: "Lato-Regular", size: CGFloat(20).relativeToWidth)
            timeLabels.append(label)
            view.addSubview(label)
            
        }
    }
    
    func purge() {
        for labels in classesLabels {
            labels.removeFromSuperview()
        }
        for labels in timeLabels {
            labels.removeFromSuperview()
        }
        classesLabels.removeAll()
        timeLabels.removeAll()
        classesString.removeAll()
        classesRaw.removeAll()
        bellSchedule.removeAll()
    }
    
    func configureHoliday() {
        noSchoolLabel.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: CGFloat(60).relativeToWidth)
        noSchoolLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y - CGFloat(40).relativeToWidth)
        noSchoolLabel.text = "NO SCHOOL TODAY"
        noSchoolLabel.font = UIFont(name: "Lato-Light", size: CGFloat(30).relativeToWidth)
        noSchoolLabel.textAlignment = .center
        noSchoolLabel.textColor = UIColor.white
        view.addSubview(noSchoolLabel)
        if today == 20 || !Date().isSchoolDay() {
            noSchoolLabel.isHidden = false
        } else {
            noSchoolLabel.isHidden = true
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
