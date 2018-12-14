//
//  HousePointsViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 10/3/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreData

class HousePointsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houses.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let house = houses[indexPath.item]
        
        if let cell = rankCollectionView.dequeueReusableCell(withReuseIdentifier: "rank", for: indexPath) as? HouseRankCollectionViewCell {
            cell.house.text = house.name.uppercased()
            if indexPath.item != 0 {
                cell.house.textColor = cell.house.textColor.withAlphaComponent(0.7)
                cell.points.textColor = cell.points.textColor.withAlphaComponent(0.7)
            }
            cell.points.text = String(house.points)
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rankCollectionView.bounds.width, height: rankCollectionView.bounds.height / 4 - CGFloat(2.5).relativeToWidth)
    }
    
    var houses = [Houses]()
    var ranksString = ["1st", "2nd", "3rd", "4th"]
    var userHouse: String?

    @IBOutlet weak var houseRankText: UILabel!
    @IBOutlet weak var housePointNumber: UILabel!
    @IBOutlet weak var trophyRank: UIImageView!
    @IBOutlet weak var ranks: UIStackView!
    @IBOutlet weak var rankCollectionView: UICollectionView!
    
    @IBOutlet weak var herPoints: UILabel!
    @IBOutlet weak var ornPoints: UILabel!
    @IBOutlet weak var pegPoints: UILabel!
    @IBOutlet weak var posPoints: UILabel!
    @IBOutlet weak var her: UIView!
    @IBOutlet weak var orn: UIView!
    @IBOutlet weak var peg: UIView!
    @IBOutlet weak var pos: UIView!
    @IBOutlet weak var herHeight: NSLayoutConstraint!
    @IBOutlet weak var ornHeight: NSLayoutConstraint!
    @IBOutlet weak var pegHeight: NSLayoutConstraint!
    @IBOutlet weak var posHeight: NSLayoutConstraint!
    @IBOutlet weak var baseline: UIView!
    
    @IBOutlet weak var rankTrailing: NSLayoutConstraint!
    @IBOutlet weak var baseLineBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        houses.removeAll()
        fetchPoints()
        self.rankCollectionView.performBatchUpdates({
            self.rankCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            
        }) { (_) in
            self.configureGraph(isInitial: false)
            if self.userHouse != nil {
                self.housePointNumber.text = self.defineRank()
            } else {
                 self.housePointNumber.text = "N/A"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        fetchPoints()
        rankCollectionView.delegate = self
        rankCollectionView.dataSource = self
        initialize()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.rankTrailing.constant = self.rankTrailing.constant.relativeToWidth
        self.baseLineBottom.constant = self.baseLineBottom.constant.relativeToWidth
        
    }
    
    func defineRank() -> String {
        for i in 0...houses.count - 1 {
            if houses[i].name.lowercased() == userHouse!.lowercased() {
                return ranksString[i]

            }
        }
        return "N/A"
    }
    
    func initialize() {
        herPoints.alpha = 0
        ornPoints.alpha = 0
        pegPoints.alpha = 0
        posPoints.alpha = 0
        herHeight.constant = 0
        ornHeight.constant = 0
        pegHeight.constant = 0
        posHeight.constant = 0
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let fetchRequest = try PersistentService.context.fetch(request)
            if let first = fetchRequest.first {
               
                userHouse = first.house
                if userHouse != nil {
                   
                    housePointNumber.text = defineRank()
                    
                } else {
                    let ac = UIAlertController(title: "No Information", message: "We don't know which house you are in. Please fill out your info under Tools -> ID Card.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                        present(ac, animated: true)
                     self.housePointNumber.text = "N/A"
                }
            } else {
                let ac = UIAlertController(title: "No Information", message: "We don't know which house you are in. Please fill out your info under Tools -> ID Card.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
                self.housePointNumber.text = "N/A"
            }
            
        } catch {
            
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureGraph(isInitial: true)
        
    }
    
    func fetchPoints() {
        if CheckInternet.Connection() {
            var name = String()
            var points = Int()

            if let data = try? String(contentsOf: URL(string: "https://spreadsheets.google.com/feeds/list/1XLgfb8kViNMPmgNy9-Gip039e_J6avIpf4k2kD46cNc/od6/public/basic?alt=json")!) {
                let jsonData = JSON(parseJSON: data)
                let entryArray = jsonData.dictionaryValue["feed"]!["entry"].arrayValue
                for entry in entryArray {
                    let house = entry["content"]["$t"].stringValue
                    let finalJSON = house.my_unquotedJSONFormatter(string: house, rows: 2)
                    if finalJSON != "error" {
                        let houseJSON = JSON(parseJSON: finalJSON)
                        let dictionary = houseJSON.dictionaryObject!
                        if let houseGet = dictionary["house"] as? String {
                            name = houseGet
                        }
                        if let pointsGet = dictionary["points"] as? String {
                            points = Int(pointsGet) ?? 1
                        }
                        
                    }
                    let houseObject = Houses()
                    houseObject.name = name
                    houseObject.points = points
                    houses.append(houseObject)
                }
                
            }
        }
        houses.sort { $0.points > $1.points }
    }


    
    
    
    func configureGraph(isInitial: Bool) {
       
        var isZero = Bool()
        var herPoint = Int()
        var ornPoint = Int()
        var pegPoint = Int()
        var posPoint = Int()
        var herPointDiff = Int()
        var ornPointDiff = Int()
        var pegPointDiff = Int()
        var posPointDiff = Int()

        for house in houses {
            if house.points == 0 {
                isZero = true
                break
            } else {
                isZero = false
                continue
            }
        }
        for house in houses {
            switch house.name {
            case "Hercules":
                herPoint = house.points
                herPointDiff = herPoint - (Int(herPoints.text!) ?? herPoint)
                
            case "Orion":
                ornPoint = house.points
                ornPointDiff = ornPoint - (Int(ornPoints.text!) ?? ornPoint)
            case "Pegasus":
                pegPoint = house.points
                pegPointDiff = pegPoint - (Int(pegPoints.text!) ?? pegPoint)
            case "Poseidon":
                posPoint = house.points
                posPointDiff = posPoint - (Int(posPoints.text!) ?? posPoint)
            default: break
            }
        }
        var divisionConstant = CGFloat()
        divisionConstant = CGFloat(1) / CGFloat(self.houses[0].points / 10)
        if isInitial {
            
            print(divisionConstant, "THIS")
            UIView.animate(withDuration: 0.7, animations: {
                if isZero {
            
                    self.herHeight.constant = CGFloat(10).relativeToWidth + divisionConstant *  CGFloat(15) *  (CGFloat(herPoint))
                    self.ornHeight.constant = CGFloat(10).relativeToWidth + divisionConstant * CGFloat(15) *  (CGFloat(ornPoint))
                    self.pegHeight.constant = CGFloat(10).relativeToWidth + divisionConstant * CGFloat(15) *  (CGFloat(pegPoint))
                    self.posHeight.constant = CGFloat(10).relativeToWidth + divisionConstant * CGFloat(15) * (CGFloat(posPoint))
                    self.view.layoutIfNeeded()
                } else {
                
                    self.herHeight.constant = CGFloat(30).relativeToWidth + CGFloat(15).relativeToWidth * (CGFloat(herPoint) - CGFloat(self.houses[self.houses.count - 1].points))
                    self.ornHeight.constant = CGFloat(30).relativeToWidth + CGFloat(15).relativeToWidth * (CGFloat(ornPoint) - CGFloat(self.houses[self.houses.count - 1].points))
                    self.pegHeight.constant = CGFloat(30).relativeToWidth + CGFloat(15).relativeToWidth * (CGFloat(pegPoint) - CGFloat(self.houses[self.houses.count - 1].points))
                    self.posHeight.constant = CGFloat(30).relativeToWidth + CGFloat(15).relativeToWidth * (CGFloat(posPoint) - CGFloat(self.houses[self.houses.count - 1].points))
                    self.view.layoutIfNeeded()
                }
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.herPoints.text = String(herPoint)
                    self.ornPoints.text = String(ornPoint)
                    self.pegPoints.text = String(pegPoint)
                    self.posPoints.text = String(posPoint)
                    self.herPoints.alpha = 1
                    self.ornPoints.alpha = 1
                    self.pegPoints.alpha = 1
                    self.posPoints.alpha = 1
                })
            }
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                    self.herHeight.constant += CGFloat(15).relativeToWidth * (CGFloat(herPointDiff) * divisionConstant)
                    self.ornHeight.constant += CGFloat(15).relativeToWidth * (CGFloat(ornPointDiff) * divisionConstant)
                    self.pegHeight.constant += CGFloat(15).relativeToWidth * (CGFloat(pegPointDiff) * divisionConstant)
                    self.posHeight.constant += CGFloat(15).relativeToWidth * (CGFloat(posPointDiff) * divisionConstant)
                    self.view.layoutIfNeeded()
               
            }) { (_) in
              
                    self.herPoints.text = String(herPoint)
                    self.ornPoints.text = String(ornPoint)
                    self.pegPoints.text = String(pegPoint)
                    self.posPoints.text = String(posPoint)
                
                
            }
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
