//
//  PickerViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import PickerView


class PickerViewController: UIViewController {
    
    enum ItemsType : Int {
        case label, customView
    }
    
    enum PresentationType {
        case numbers(Int, Int), names(Int, Int)
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var pickerView: PickerView!
    @IBAction func cancelTapped(_ sender: Any) {
        selectedItem = nil
        performSegue(withIdentifier: "backToClass", sender: nil)
    }
    @IBAction func doneTapped(_ sender: Any) {
        if currentSelectedValue != nil {
              selectedItem = currentSelectedValue!
            switch currentSelectedValue {
            case "English", "Social Studies", "Math", "Physical Education", "Science", "Sport", "Free Period":
                performSegue(withIdentifier: "backToClass", sender: nil)
            case "Visual and Performing Arts", "World Language", "General Electives", "ROP":
                performSegue(withIdentifier: "detailClass", sender: nil)
            default: break
            }
         
        }
    }
    
   
    
    let classes = ["English", "Social Studies", "Math", "Physical Education", "Science", "Visual and Performing Arts", "World Language", "General Electives", "ROP", "Sport", "Free Period"]
    
    var presentationType = PresentationType.numbers(0, 0)
    var selectedItem: String?
    var currentSelectedValue: String?
    var updateSelectedValue: ((_ newSelectedValue: String) -> Void)?
    
    var itemsType: PickerViewController.ItemsType = .label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
        configurePicker()
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailClass" {
            let vc = segue.destination as? DetailPickerViewController
            vc!.selectedSubject = self.selectedItem!
        }
    }
 

}

extension PickerViewController: PickerViewDelegate {
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
        currentSelectedValue = self.classes[index]
    }
}

extension PickerViewController: PickerViewDataSource {
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
      
        return classes.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
   
        return classes[index]
    }
    
    
}
