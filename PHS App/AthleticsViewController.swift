//
//  AthleticsViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/17/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import Segmentio

class AthleticsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentioView: Segmentio!
    var content = [SegmentioItem]()
    let allIcons = ["Baseball", "Boys Basketball", "Track", "Football", "Girls Golf", "Girls Lacrosse", "Boys Soccer", "Softball", "Girls Tennis", "Swim", "Cross Country", "Girls Volleyball", "Boys Water Polo","Wrestling", "Girls Basketball", "Boys Golf", "Boys Lacrosse", "Girls Soccer", "Boys Tennis", "Girls Water Polo", "Boys Volleyball"]
    let allImages: [UIImage] = [
        UIImage(named: "Baseball")!,
        UIImage(named: "Basketball")!,
        UIImage(named: "Track")!,
        UIImage(named: "Football")!,
        UIImage(named: "Golf")!,
        UIImage(named: "Lacrosse")!,
        UIImage(named: "Soccer")!,
        UIImage(named: "Softball")!,
         UIImage(named: "Tennis")!,
        UIImage(named: "Swim")!,
        UIImage(named: "CrossCountry")!,
        UIImage(named: "Volleyball")!,
        UIImage(named: "Water Polo")!,
        UIImage(named: "Wrestling")!,
        UIImage(named: "Basketball")!,
        UIImage(named: "Golf")!,
        UIImage(named: "Lacrosse")!,
        UIImage(named: "Soccer")!,
         UIImage(named: "Tennis")!,
        UIImage(named: "Water Polo")!,
        UIImage(named: "Swim")!,
        UIImage(named: "Volleyball")!
    ]
    
    let fallIndex: [Int] = [3, 4, 8, 10, 11, 12]
    let winterIndex: [Int] = [1, 6, 17, 14, 13, 19]
    let springIndex: [Int] = [0, 2, 5, 7, 9, 15, 16, 18, 20]
    
    var fallIcons = [String]()
    var winterIcons = [String]()
    var springIcons = [String]()
    var fallImages = [UIImage]()
    var winterImages = [UIImage]()
    var springImages = [UIImage]()
    
    var onDisplay = [String]()
    var displayedImages = [UIImage]()
    
    var sportToPass = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        setSegmentedControl()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        segmentioView.selectedSegmentioIndex = 0
        onDisplay = allIcons
        displayedImages = allImages
        
        for index in fallIndex {
            fallIcons.append(allIcons[index])
            fallImages.append(allImages[index])
        }
        
        for index in winterIndex {
            winterIcons.append(allIcons[index])
            winterImages.append(allImages[index])
        }
        for index in springIndex {
            springIcons.append(allIcons[index])
            springImages.append(allImages[index])
        }
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: self.view.bounds.width / 2, height: self.view.bounds.width / 2)
        collectionView.allowsMultipleSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for cell in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: cell, animated: true)
            let deselectedCell = collectionView.cellForItem(at: cell)
            deselectedCell?.backgroundColor = UIColor.white
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            switch segmentIndex {
            case 0:
                self.onDisplay = self.allIcons
                self.displayedImages = self.allImages
            case 1:
                self.onDisplay = self.fallIcons
                self.displayedImages = self.fallImages
            case 2:
                self.onDisplay = self.winterIcons
                self.displayedImages = self.winterImages
            case 3:
                self.onDisplay = self.springIcons
                self.displayedImages = self.springImages
            default:
                self.onDisplay = self.allIcons
                self.displayedImages = self.allImages
            }
            self.collectionView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let allItem = SegmentioItem(title: "ALL", image: nil)
        let fallItem = SegmentioItem(title: "FALL", image: nil)
        let winterItem = SegmentioItem(title: "WINTER", image: nil)
        let springItem = SegmentioItem(title: "SPRING", image: nil)
        content = [allItem, fallItem, winterItem, springItem]
        segmentioView.setup(content: content, style: .onlyLabel, options: options)
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sports", for: indexPath) as! AthleticsCollectionViewCell
        cell.iconImage.image = displayedImages[indexPath.item]
        cell.iconLabel.text = onDisplay[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        let item = cell as! AthleticsCollectionViewCell
        sportToPass = item.iconLabel.text!
        performSegue(withIdentifier: "athleticDetail", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "athleticDetail" {
            let vc = segue.destination as! AthleticsDetailViewController
            vc.sport = sportToPass
            
        }
    }
 

}
