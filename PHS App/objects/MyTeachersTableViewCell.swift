//
//  MyTeachersTableViewCell.swift
//  PHS App
//
//  Created by Patrick Cui on 8/20/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import MessageUI

class MyTeachersTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailButtonView: UIView!
    var first = String()
    var last = String()
    var gender = Bool()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleView.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
        circleView.layer.cornerRadius = 25
        emailButtonView.layer.cornerRadius = 25
        emailButtonView.layer.borderWidth = 2
        emailButtonView.layer.borderColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0).cgColor
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        gestureRecognizer.delegate = self
        emailButtonView.addGestureRecognizer(gestureRecognizer)
        
        teacherLabel.text = "\(first.uppercased()) \(last.uppercased())"
        circleView.my_dropShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        circleView.backgroundColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
    }
    
    @objc func emailTapped() {
        emailButtonView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.45)
        var address = String()
        let trimmedLast = last.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        
            address = "\(first)\(trimmedLast)@iusd.org"
       
        sendEmail(address: address, isFemale: gender, lastName: last)
    }
    
    func sendEmail(address: String, isFemale: Bool, lastName: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            var title = String()
                if isFemale {
                    title = "Ms."
                } else {
                    title = "Mr."
                }
            
            
            mail.setMessageBody("<p>Hello, \(title) \(lastName), <br><br><br> <br>Sincerely,", isHTML: true)
            self.parentViewController?.present(mail, animated: true)
        } else {
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        emailButtonView.backgroundColor = UIColor.white
        self.parentViewController?.dismiss(animated: true)
    }
    
    
    

}
