//
//  TeacherPickerViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import PickerView


class TeacherPickerViewController: UIViewController {

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
            performSegue(withIdentifier: "backToTeacher", sender: nil)
        }
    }
    
    
    var selectedSubject = String()

    var teacherObjects = [NewTeachers]()
    
    
    var presentationType = PresentationType.numbers(0, 0)
    var selectedItem: NewTeachers?
    var currentSelectedValue: NewTeachers?
    var updateSelectedValue: ((_ newSelectedValue: String) -> Void)?
    
    var itemsType: PickerViewController.ItemsType = .label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.my_setNavigationBar()
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
        if let currentSelected = currentSelectedValue, let indexOfCurrentSelectedValue = teacherObjects.index(of: currentSelected) {
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

extension TeacherPickerViewController: PickerViewDelegate {
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
        
            currentSelectedValue = self.teacherObjects[index]
            
        
    }
}

extension TeacherPickerViewController: PickerViewDataSource {
    func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        return ""
    }
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        
        return teacherObjects.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        
        return "\(teacherObjects[index].first) \(teacherObjects[index].last)"
    }
    
    
}
