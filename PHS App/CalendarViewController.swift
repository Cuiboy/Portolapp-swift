//
//  CalendarViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/13/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
  
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarHolder: UIView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var  noSchoolLabel: UILabel!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dateDetail: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var startEndLabel: UILabel!
    
    
     let formatter = DateFormatter()
    var specialDates = [Date]()
    var dateRange = [Date]()
    func initializeCalendar() {
        calendarHolder.layer.shadowColor = UIColor.gray.cgColor
        calendarHolder.layer.shadowRadius = 4
        calendarHolder.layer.shadowOpacity = 0.35
        calendarHolder.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.minimumInteritemSpacing = 0
        calendarView.minimumLineSpacing = 0
        calendarView.allowsMultipleSelection = false
        calendarView.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
       
        
        
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date).uppercased()
        }
       
        
        
        dateDetail.layer.shadowColor = UIColor.gray.cgColor
        dateDetail.layer.shadowRadius = 4
        dateDetail.layer.shadowOpacity = 0.35
        dateDetail.layer.shadowOffset = CGSize(width: 5, height: 5)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        backgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        initializeCalendar()
        for objects in specialDays {
            specialDates.append(objects.date.noon)
        }
        let leftGesture = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        leftGesture.delegate = self
        leftArrow.addGestureRecognizer(leftGesture)
        let rightGesture = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
        rightGesture.delegate = self
        rightArrow.addGestureRecognizer(rightGesture)
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2018 08 01")!
        let endDate = formatter.date(from: "2019 08 31")!
        dateRange = calendarView.generateDateRange(from: startDate, to: endDate)
        configureDayDetail(withDate: Date().noon)
        calendarView.scrollToDate(Date(), animateScroll: false)

      
    }
   
    
    
    
    func configureDayDetail(withDate date: Date) {
        periodLabel.isHidden = false
        startEndLabel.isHidden = false
        noSchoolLabel.isHidden = true
        var dayType = getDayType(date: date)
        if dayType == 0 {
            dayType = Calendar.current.component(.weekday, from: date) + 20
        }
        dateLabel.text = "\(Calendar.current.component(.month, from: date))/\(Calendar.current.component(.day, from: date))"
        weekdayLabel.text = getWeekdayString(date: date, isUpper: true)
        if date.isSchoolDay() {
            let periods = my_getPeriodsFromToday(type: dayType)
            periodLabel.text = periods.joined(separator: ", ")
            let schedule = my_getSchedule(type: dayType, date: nil)
            let start = schedule!.first!
            let end = schedule!.last!
          
            let hourStart = Calendar.current.component(.hour, from: start)
            let minuteStart = Calendar.current.component(.minute, from: start)
            let hourEnd = Calendar.current.component(.hour, from: end)
            let minuteEnd = Calendar.current.component(.minute, from: end)
            var startComponents = DateComponents()
            startComponents.year = Calendar.current.component(.year, from: date)
            startComponents.month = Calendar.current.component(.month, from: date)
            startComponents.day = Calendar.current.component(.day, from: date)
            startComponents.hour = hourStart - UTCDifference()
            startComponents.minute = minuteStart
            var endComponents = DateComponents()
            endComponents.year = Calendar.current.component(.year, from: date)
            endComponents.month = Calendar.current.component(.month, from: date)
            endComponents.day = Calendar.current.component(.day, from: date)
            endComponents.hour = hourEnd - UTCDifference()
            endComponents.minute = minuteEnd
            let formatter = DateFormatter()
            formatter.timeZone = Calendar.current.timeZone
            formatter.dateFormat = "h:mm a"
            let newStart = Calendar.current.date(from: startComponents)!
            let newEnd = Calendar.current.date(from: endComponents)!
            print(newStart, newEnd)
            startEndLabel.text = "\(formatter.string(from: newStart)) - \(formatter.string(from: newEnd))"
            
            
        } else {
            periodLabel.isHidden = true
            startEndLabel.isHidden = true
            noSchoolLabel.isHidden = false
        }
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if calendarView.visibleDates().indates.first!.date < dateRange.first! {
            leftArrow.isHidden = true
        } else {
            leftArrow.isHidden = false
        }
        
      
    }
    
   
    @objc func leftTapped() {
        let scrollDate = calendarView.visibleDates().indates.first!.date
        calendarView.scrollToDate(scrollDate)
    }

    @objc func rightTapped() {
         let scrollDate = calendarView.visibleDates().outdates.first!.date
        calendarView.scrollToDate(scrollDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func handleCellConfiguration(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCollectionViewCell else {return}
        if cellState.date.noon == Date().noon {
            
            validCell.selectedView.isHidden = false
            validCell.dateLabel.textColor = UIColor.white
            
        } else {
            if validCell.isSelected {
                validCell.dateLabel.textColor = UIColor.white
                 validCell.selectedView.isHidden = false
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
                } else {
                    validCell.dateLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
                }
                validCell.selectedView.isHidden = true
            }
        }
    }
    
    func configureDots(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCollectionViewCell else {return}
        if !specialDates.contains(cellState.date.noon) {
            validCell.dotView.isHidden = true
        } else {
            validCell.dotView.isHidden = false
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dotView.backgroundColor = validCell.dotView.backgroundColor
            } else {
                validCell.dotView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            }

        }
       
    }
  
    func configureDotsWhenScroll(view: JTAppleCalendarView?, visibleDates: DateSegmentInfo) {
        for days in visibleDates.monthDates {
          
            guard let cell = view?.cellForItem(at: days.indexPath) as? CalendarCollectionViewCell else {return}
            if cell.dotView.isHidden == false {
                cell.dotView.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
            }
        }
        for days in visibleDates.indates + visibleDates.outdates {
            guard let cell = view?.cellForItem(at: days.indexPath) as? CalendarCollectionViewCell else {return}
            if cell.dotView.isHidden == false {
                cell.dotView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            }
            
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
       handleCellConfiguration(view: cell, cellState: cellState)
        configureDots(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        handleCellConfiguration(view: cell, cellState: cellState)
         configureDots(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(view: cell, cellState: cellState)
        configureDayDetail(withDate: date)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
          handleCellConfiguration(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
   
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date).uppercased()
        configureDotsWhenScroll(view: calendar, visibleDates: visibleDates)
        if visibleDates.indates.first!.date < dateRange.first! {
            leftArrow.isHidden = true
        } else {
            leftArrow.isHidden = false
        }
        if visibleDates.outdates.first!.date > dateRange.last! {
            rightArrow.isHidden = true
        } else {
            rightArrow.isHidden = false
            
        }
        
        
    }
    
    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        calendarView.deselectAllDates()
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
       
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2018 08 01")!
        let endDate = formatter.date(from: "2019 08 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
  
}
