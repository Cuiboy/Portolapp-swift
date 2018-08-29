//
//  AthleticsDetailViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/20/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import Segmentio
import UserNotifications

class AthleticsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if upcomingGames.count >= 3 {
            return 3
        } else {
            return upcomingGames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: upcomingView.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = upcomingView.dequeueReusableCell(withReuseIdentifier: "upcoming", for: indexPath) as! UpcomingGamesCollectionViewCell
        let game = upcomingGames[indexPath.item]
        cell.PortolaLabel.text = "PORTOLA"
     
        cell.purpleCircle.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
        cell.purpleCircle.layer.cornerRadius = 35
        cell.purpleCircle.my_dropShadow()
        cell.grayCircle.backgroundColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.0)
        cell.grayCircle.layer.cornerRadius =  35
        cell.grayCircle.my_dropShadow()
        cell.awayInitial.text = String(Array(game.other!).first!)
        cell.awayLabel.text = game.other?.uppercased()
        cell.team.text = "VARSITY"
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM. dd"
        cell.date.text = formatter.string(from: game.time).uppercased()
        if game.isAway {
            cell.location.text = "AWAY"
        } else {
            cell.location.text = "HOME"
        }
        
        return cell
        
        
    }
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        schedule.removeAll()
        performSelector(inBackground: #selector(loadSchedule), with: nil)
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var segmentioView: Segmentio!
    var content = [SegmentioItem]()
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("GameScheduleTableViewCell", owner: self, options: nil)?.first as! GameScheduleTableViewCell
        cell.sport = sport
        let game = schedule[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.dateFormat = "M/dd"
        cell.date.text = dateFormatter.string(from: game.time)
        let weekFormatter = DateFormatter()
        weekFormatter.timeZone = Calendar.current.timeZone
        weekFormatter.dateFormat = "EEEE"
        let weekdayString = weekFormatter.string(from: game.time).uppercased()
        cell.weekday.text = weekdayString
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = Calendar.current.timeZone
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: game.time)
        cell.time.text = timeString
        if game.isAway {
            cell.isAway.text = "AWAY"
        } else {
            cell.isAway.text = "HOME"
        }
        cell.gameTime = game.time
        cell.identifier = "\(sport)\(Calendar.current.component(.day, from: game.time))\(Calendar.current.component(.month, from: game.time))"
        UNUserNotificationCenter.current().getPendingNotificationRequests { request in
            for notification in request {
                if cell.identifier == notification.identifier {
                    cell.notification = true
                    DispatchQueue.main.async {
                        cell.bell.alpha = 1
                        
                }
                    break
                } else {
                    cell.notification = false
                    DispatchQueue.main.async {
                        cell.bell.alpha = 0
                    }
                }
            }
        }
        if game.homeScore != nil && game.awayScore != nil {
            print("called")
            cell.gameScheduleView.alpha = 0
            cell.gameResultView.alpha = 1
        cell.homeScore.text = String(game.homeScore!)
        cell.awayScore.text = String(game.awayScore!)
            if game.isAway {
                cell.homeTeam.text = game.other?.uppercased()
                cell.otherTeam = game.other ?? " "
                cell.awayTeam.text = "PORTOLA"
            } else {
                cell.homeTeam.text = "PORTOLA"
                cell.otherTeam = game.other ?? " "
                cell.awayTeam.text = game.other?.uppercased()
            }
            
        } else {
            cell.gameScheduleView.alpha = 1
            cell.gameResultView.alpha = 0
            cell.sendSubview(toBack: cell.gameResultView)
            cell.awayTeamSchedule.text = game.other?.uppercased()
            cell.otherTeam = game.other ?? " "
            
        }
      return cell
    }
    
    var sport = String()

    @IBOutlet weak var scheduleView: UITableView!
    var schedule = [Games]()
    var upcomingGames = [Games]()
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var upcomingView: UICollectionView!
    
    
    @IBOutlet weak var overall: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var varsity: UILabel!
    @IBOutlet weak var upcoming: UILabel!
    @IBOutlet weak var nothingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem!.title = sport
        record.alpha = 0
        nothingLabel.alpha = 0
        navigationBar.my_setNavigationBar()
        scheduleView.delegate = self
        scheduleView.dataSource = self
        upcomingView.delegate = self
        upcomingView.dataSource = self
        setSegmentedControl()
        segmentioView.selectedSegmentioIndex = 0
        homeView.frame = CGRect(x: 0, y: segmentioView.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - segmentioView.frame.maxY)
        record.font = record.font.withSize(CGFloat(58).relativeToWidth)
        overall.font = overall.font.withSize(CGFloat(19).relativeToWidth)
        varsity.font = varsity.font.withSize(CGFloat(18).relativeToWidth)
        upcoming.font = upcoming.font.withSize(CGFloat(19).relativeToWidth)
      
        view.addSubview(scheduleView)
        view.bringSubview(toFront: homeView)
         view.bringSubview(toFront: segmentioView)
        performSelector(inBackground: #selector(loadSchedule), with: nil)
        let layout = self.upcomingView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = -10
    
      
        
        
        
    }
    
    @objc func loadSchedule() {
   
        if CheckInternet.Connection() {
            
            if let data = try? String(contentsOf: URL(string: "https://portola.epicteam.app/api/sports")!) {
                
                let jsonData = JSON(parseJSON: data)
                
                if let array = jsonData.dictionaryValue["sports"]?.arrayValue {
                    
                    for item in array {
                        
                        if let parsedInfo = item.dictionaryObject {
                            if let name = parsedInfo["name"] as? String {
                              
                                if name == sport {
                                  
                                   
                                            let game = Games()
                                            game.sport = sport
                                            if let date = parsedInfo["when"] as? String {
                                              
                                                if #available(iOS 11.0, *) {
                                                      let formatter = ISO8601DateFormatter()
                                                    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                                                    game.time = formatter.date(from: date) ?? Date.distantPast
                                                } else {
                                                    let formatter = DateFormatter()
                                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                                                    game.time = formatter.date(from: date) ?? Date.distantPast
                                                }
                                                
                                            }
                                            if let opponent = parsedInfo["other"] as? String {
                                                game.other = opponent
                                            } else {
                                                game.other = nil
                                            }
                                            if let isAway = parsedInfo["is_away"] as? Bool {
                                                game.isAway = isAway
                                            }
                                            if let home = parsedInfo["home_score"] as? Int {
                                                game.homeScore = home
                                            } else {
                                                game.homeScore = nil
                                            }
                                            if let away = parsedInfo["away_score"] as? Int {
                                                game.awayScore = away
                                            } else {
                                                game.awayScore = nil
                                            }
                                            schedule.append(game)
                                    
                                    if game.time > Date() {
                                        upcomingGames.append(game)
                                    }
                                    
                                } else {
                                    continue
                                }
                        }
                       
                            
                        }
                    }
                }
              
                
            }
            DispatchQueue.main.async {
                self.scheduleView.reloadData()
                self.upcomingView.reloadData()
                self.configureHome()

            }
            
        } else {
            let ac = UIAlertController(title: "No Internet Connection", message: "Cannot load schedule because there is no internet connection.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                self.dismiss(animated: true)
            }))
        }
    }
    
    func configureHome() {
        var wins = 0
        var losses = 0
        var ties: Int? = nil
        for games in schedule {
            if games.homeScore != nil && games.awayScore != nil {
                if games.isAway {
                    if games.homeScore! < games.awayScore! {
                        wins += 1
                    } else if games.homeScore! > games.awayScore! {
                        losses += 1
                    } else {
                        if ties == nil {
                            ties = 1
                        } else {
                            ties! += 1
                        }
                    }
                } else {
                    if games.homeScore! > games.awayScore! {
                        wins += 1
                    } else if games.homeScore! < games.awayScore! {
                        losses += 1
                    } else {
                        if ties == nil {
                            ties = 1
                        } else {
                            ties! += 1
                        }
                    }
                }
            }
        }
        if ties == nil {
            record.text = "\(wins)-\(losses)"
        } else {
            record.text = "\(wins)-\(ties!)-\(losses)"
        }
        record.alpha = 1
        if upcomingGames.count == 0 {
            nothingLabel.alpha = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            switch segmentIndex {
            case 0:
               self.view.sendSubview(toBack: self.scheduleView)
            case 1:
                self.view.bringSubview(toFront: self.scheduleView)

            default:
                break
            }
        }
    }
    
    func setSegmentedControl() {
        
        view.addSubview(segmentioView)
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
        let home = SegmentioItem(title: "HOME", image: nil)
        let schedule = SegmentioItem(title: "SCHEDULE", image: nil)
        
        content = [home, schedule]
        segmentioView.setup(content: content, style: .onlyLabel, options: options)
        
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
