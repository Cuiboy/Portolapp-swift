//
//  DetailPickerViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import PickerView


let worldLanguage = ["Spanish", "French", "Chinese", "Korean", "Latin", "Other"]
let rop = ["Intro to Med Careers", "Sprots Medicine", "Video Production", "Computer Graphics", "Other"]
let vapa = ["Art Studio", "Ceramics", "Arts Survey", "Drawing & Painting", "Visual Imagery", "Computer Graphics",  "Video Production", "Art Portfolio Prep", "AP Art History", "Dance", "Guitar", "Drama", "Tech Theatre", "Studio Music", "Marching Band", "Color Guard", "Band", "Orchestra", "Choir", "Portola Singers", "AP Music Theory", "Other"]
let others = ["ASB", "Health", "Computer Science", "Yearbook", "Adv. Newspaper", "Modern Media",  "Video Production", "Other"]

class DetailPickerViewController: UIViewController {

    enum ItemsType : Int {
        case label, customView
    }
    
    enum PresentationType {
        case numbers(Int, Int), names(Int, Int)
    }
    
 
    
    @IBOutlet weak var navigationBar: UINavigationBar!
  
    @IBOutlet weak var pickerView: PickerView!
 
    @IBAction func cancelTapped(_ sender: Any) {
      dismiss(animated: true)
    }
   
    @IBAction func doneTapped(_ sender: Any) {
        if currentSelectedValue != nil {
            selectedItem = currentSelectedValue!
            performSegue(withIdentifier: "detailBackToClass", sender: nil)
        }
    }
    
   
    var selectedSubject = String()
    var classes = [String]()

    
    
    var presentationType = PresentationType.numbers(0, 0)
    var selectedItem: String?
    var currentSelectedValue: String?
    var updateSelectedValue: ((_ newSelectedValue: String) -> Void)?
    
    var itemsType: PickerViewController.ItemsType = .label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        switch selectedSubject {
        case "Visual and Performing Arts":
            classes = vapa
        case "World Language":
            classes = worldLanguage
        case "ROP":
            classes = rop
        case "General Electives":
            classes = others
        default:
            classes = vapa + rop + worldLanguage + others
        }
        configurePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    
    fileprivate func configurePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.scrollingStyle = .default
        pickerView.selectionStyle = .none
        if let currentSelected = currentSelectedValue, let indexOfCurrentSelectedValue = classes.index(of: currentSelected) {
            pickerView.currentSelectedRow = indexOfCurrentSelectedValue
        }
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


extension DetailPickerViewController: PickerViewDelegate {
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        
        return 50.0
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        
        label.textAlignment = .center
        if (highlighted) {
            label.font = UIFont(name: "Lato-Light", size: CGFloat(28).relativeToWidth)
            label.textColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
        } else {
            label.font = UIFont(name: "Lato-Light", size: CGFloat(18).relativeToWidth)
            label.textColor = UIColor.lightGray.withAlphaComponent(0.75)
        }
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        if self.classes[index] == "Other" {
            currentSelectedValue = selectedSubject
        } else {
            currentSelectedValue = self.classes[index]

        }
    }
}

extension DetailPickerViewController: PickerViewDataSource {
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        
        return classes.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        
        return classes[index]
    }
    
    
}
