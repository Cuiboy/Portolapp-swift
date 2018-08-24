//
//  SubjectsExpandedTableViewCell.swift
//  PHS App
//
//  Created by Patrick Cui on 8/17/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//


import UIKit
import CoreGraphics
import MessageUI


class SubjectsExpandedTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailImageView: UIImageView!
    var first = String()
    var last = String()
    var gender = Bool()
    var email: String?
    static let ID = "expandedCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        gestureRecognizer.delegate = self
        emailImageView.addGestureRecognizer(gestureRecognizer)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.frame.height * 0.9, height: self.frame.height * 0.9))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0).cgColor)
            ctx.cgContext.setStrokeColor(UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0).cgColor)
            ctx.cgContext.setLineWidth(1)
            
            let rectangle = CGRect(x: 1, y: 1, width: self.frame.height * 0.8, height: self.frame.height * 0.8)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        circleImageView.image = img
        circleImageView.my_dropShadow()
        initialsLabel.my_dropShadow()
    }

    @objc func emailTapped() {
        var address = String()
        let trimmedLast = last.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        if email == nil {
             address = "\(first)\(trimmedLast)@iusd.org"
        } else {
             address = email!
        }
        sendEmail(address: address, isFemale: gender, lastName: last)
    }

    
    func sendEmail(address: String, isFemale: Bool, lastName: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            var title = String()
            if email == nil {
                if isFemale {
                    title = "Ms."
                } else {
                    title = "Mr."
                }
            } else {
               title = "Coach"
            }
            
            mail.setMessageBody("<p>Hello, \(title) \(lastName), <br><br><br> <br>Sincerely,", isHTML: true)
            self.parentViewController?.present(mail, animated: true)
        } else {
            
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.parentViewController?.dismiss(animated: true)
    }
    
    
    
}
