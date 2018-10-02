//
//  GameScheduleTableViewCell.swift
//  PHS App
//
//  Created by Patrick Cui on 8/20/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import UserNotifications

class GameScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var gameResultView: UIView!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var gameScheduleView: UIView!
    @IBOutlet weak var awayTeamSchedule: UILabel!
    @IBOutlet weak var bell: UIImageView!
    @IBOutlet weak var bellOutline: UIImageView!
    @IBOutlet weak var calendar: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var isAway: UILabel!
  
    var notification = false
    var sport = String()
    var gameTime = Date()
    var otherTeam = String()
   let store = EKEventStore()
    var identifier = String()
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bell.alpha = 0
      
        let labels: [UILabel] = [homeScore, awayScore, awayTeam, homeTeam, awayTeamSchedule, date, weekday, time, isAway]
        for label in labels {
            label.font = label.font.withSize(label.font.pointSize.relativeToWidth)
        }
        
        bellOutline.isUserInteractionEnabled = true
        calendar.isUserInteractionEnabled = true
        let bellGesture = UITapGestureRecognizer(target: self, action: #selector(bellTapped))
        bellGesture.delegate = self
        bellOutline.addGestureRecognizer(bellGesture)
        
        let calendarGesture = UITapGestureRecognizer(target: self, action: #selector(calendarTapped))
        calendarGesture.delegate = self
        calendar.addGestureRecognizer(calendarGesture)
    }
    
    @objc func bellTapped() {

            notification = !notification
           
        
                     if self.notification {
                        UIView.animate(withDuration: 0.3) {
                               self.bell.alpha = 1
                        }
                        self.scheduleLocal()

                     } else {
                        UIView.animate(withDuration: 0.3) {
                             self.bell.alpha = 0
                        }
                       
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            
        }
        
    }

    @objc func calendarTapped() {

        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: gameTime)!
        createEventinTheCalendar(with: "\(sport) vs \(otherTeam)", forDate: gameTime, toDate: endTime)
    }
    
    func createEventinTheCalendar(with title: String, forDate eventStartDate: Date, toDate eventEndDate: Date) {
        
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
                event.addAlarm(alarm)
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    let ac = UIAlertController(title: "Saved Successfully", message: "We have saved this game to your calendar.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.parentViewController?.present(ac, animated: true)
                } catch {
                
                    let ac = UIAlertController (title: "Could not save evnent", message: "There was an error saving your event, go to settings to double-check calendar usage permission.?", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                
                            })
                        }
                    }
                    ac.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    ac.addAction(cancelAction)
                    
                   self.parentViewController?.present(ac, animated: true, completion: nil)
                    
                }
                
            } else {
                //we have error in getting access to device calnedar
                 self.setAlertController(title: "Could not save evnent", message: "There was an error saving your event, go to settings to double-check calendar usage permission.", preferredStyle: .alert, actionTitle: "OK")
            }
        }
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print(self.gameTime)
                let dateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: self.gameTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let content = UNMutableNotificationContent()
                content.title = "\(self.sport) vs \(self.otherTeam)"
                content.body = "\(self.sport)'s will play \(self.otherTeam) soon, go to the game and show your support!"
                content.sound = UNNotificationSound.default
            
               
                let request = UNNotificationRequest(identifier: self.identifier, content: content, trigger: trigger)
                center.add(request)
            } else {
                let ac = UIAlertController (title: "No Permission", message: "We do not ahve permission to send you notifications, would you like to change that in settings?", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            
                        })
                    }
                }
                ac.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                ac.addAction(cancelAction)
                
                self.parentViewController?.present(ac, animated: true, completion: nil)
                }
        }
    }
    
    
    
    func setAlertController(title: String, message: String?, preferredStyle: UIAlertController.Style, actionTitle: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        ac.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.parentViewController?.present(ac, animated: true)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
