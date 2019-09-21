//
//  ViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 7/22/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import CoreGraphics
//import XLActionController


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  
    var isFreshLaunch = true
    var safeArea = CGFloat() 
    @IBOutlet weak var navigationBackground: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let icons = ["Clubs", "Teachers", "ID Card", "Call", "Calendar", "Portola Pilot", "PNN"]
    let iconImages: [UIImage] = [
        UIImage(named: "clubs")!,
        UIImage(named: "teachers")!,
        UIImage(named: "id")!,
        UIImage(named: "call")!,
        UIImage(named: "calendar")!,
        UIImage(named: "pilot")!,
        UIImage(named: "pnn")!,
        UIImage(named: "housePoints")!
    ]
    
    let currentIcons = ["Teachers", "ID Card", "Call", "Calendar", "Portola Pilot", "House Points"]
    let currentIconImages: [UIImage] = [
        UIImage(named: "teachers")!,
        UIImage(named: "id")!,
        UIImage(named: "call")!,
        UIImage(named: "calendar")!,
        UIImage(named: "pilot")!,
        UIImage(named: "housePoints")!
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        if isFreshLaunch {
            self.tabBarController!.selectedIndex = 1
            isFreshLaunch = false
        }
        
        for cell in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: cell, animated: true)
            let deselectedCell = collectionView.cellForItem(at: cell)
            deselectedCell?.backgroundColor = UIColor.white
        }
        
    }
    


    
   
    
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        drawLines()
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (self.view.bounds.width) / 2, height: safeArea / 4)
        
        
    }
    
    
    
    func drawLines() {
        let safeTopY = navigationBar.bounds.maxY - (20 - UIApplication.shared.statusBarFrame.height)
       
        var bottomConstant = 0
        if UIScreen.main.bounds.height == 812 {
            bottomConstant = 34
        }
        let safeBottomY = tabBarController!.tabBar.frame.minY - CGFloat(bottomConstant)
        safeArea = safeBottomY - safeTopY
        
        let renderer1 = UIGraphicsImageRenderer(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let img1 = renderer1.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor(red:0.82, green:0.70, blue:0.88, alpha:1.0).cgColor)
            ctx.cgContext.setLineWidth(0.5)
            
            ctx.cgContext.move(to: CGPoint(x: self.view.bounds.midX, y: navigationBar.frame.maxY  - (20 - UIApplication.shared.statusBarFrame.height)) )
            ctx.cgContext.addLine(to: CGPoint(x: self.view.bounds.midX, y: self.view.bounds.height))
            ctx.cgContext.move(to: CGPoint(x: 0, y: safeTopY + safeArea / 2))
            ctx.cgContext.addLine(to: CGPoint(x: self.view.bounds.maxX, y: safeTopY + safeArea / 2))
            ctx.cgContext.move(to: CGPoint(x: 0, y: safeTopY + safeArea / 4))
            ctx.cgContext.addLine(to: CGPoint(x: self.view.bounds.maxX, y: safeTopY + safeArea / 4))
            ctx.cgContext.move(to: CGPoint(x: 0, y: safeTopY + safeArea / 4 * 3))
            ctx.cgContext.addLine(to: CGPoint(x: self.view.bounds.maxX, y: safeTopY + safeArea / 4 * 3))
     
            ctx.cgContext.drawPath(using: .stroke)
        }
         let image = UIImageView(image: img1)
        image.image = img1
       
        
        
        }

    func callNumber(number: String) {
         let numberString = number
        guard let url = URL(string: "telprompt://\(numberString)") else {
           
            return
            
        }
        UIApplication.shared.open(url)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.iconLabel.text = currentIcons[indexPath.item]
        cell.iconImageView.image = currentIconImages[indexPath.item]
        if currentIcons[indexPath.item] == "Clubs" {
            cell.iconLabel.textColor = UIColor.gray
        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let item = cell as? CollectionViewCell {
            if item.iconLabel.text != "Call" {
                cell?.layer.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha: 0.6).cgColor
            }
        }
        
        let cellItem = cell as! CollectionViewCell
        switch cellItem.iconLabel.text! {
        case "Call":
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Front Office", style: .default, handler: { (_) in
            self.callNumber(number: "9499368200")
        }))
            ac.addAction(UIAlertAction(title: "Attedance Office", style: .default, handler: { (_) in
            self.callNumber(number: "9499368201")
        }))
            ac.addAction(UIAlertAction(title: "Counseling Office", style: .default, handler: { (_) in
            self.callNumber(number: "9499368227")
        }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
            
            
        default:
            let vc = storyboard?.instantiateViewController(withIdentifier: cellItem.iconLabel.text!)
            present(vc!, animated: true)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
         if cell.iconLabel.text == "Call" {
                if cell.isSelected {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    return true
                }
            } else {
                return true
                }
        }
       return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

