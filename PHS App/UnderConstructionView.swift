//
//  UnderConstructionView.swift
//  PHS App
//
//  Created by Patrick Cui on 8/18/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import MessageUI

class UnderConstructionView: UIView, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet var contentView: UnderConstructionView!
    @IBOutlet weak var underConstructionLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    var buttonView = UIView()
    var buttonLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("UnderConstructionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        underConstructionLabel.font = underConstructionLabel.font.withSize(CGFloat(24).relativeToWidth)
        buttonView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.45, height: CGFloat(40).relativeToWidth)
        buttonView.center = CGPoint(x: UIScreen.main.bounds.midX, y: bottomLabel.frame.maxY + CGFloat(35).relativeToWidth)
        buttonView.clipsToBounds = true
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0).cgColor
        buttonLabel.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.45, height: CGFloat(40).relativeToWidth)
        buttonLabel.center = CGPoint(x: UIScreen.main.bounds.width * 0.45 * 0.5, y: CGFloat(40).relativeToWidth / 2)
        buttonLabel.text = "JOIN US"
        buttonLabel.textAlignment = .center
        buttonLabel.font = UIFont(name: "Lato-Light", size: CGFloat(18).relativeToWidth)
        buttonLabel.textColor = UIColor(red:0.42, green:0.25, blue:0.57, alpha:1.0)
        buttonView.addSubview(buttonLabel)
        buttonView.bringSubviewToFront(buttonLabel)
        self.addSubview(buttonView)
        buttonView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(joinUsTapped))
        gestureRecognizer.delegate = self
        buttonView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func joinUsTapped() {
        buttonView.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha: 0.6)
        let address = "patrickcui1122@icloud.com"
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            mail.setSubject("Interested in Joining Portola App Team")
            self.parentViewController?.present(mail, animated: true)
            
        } else {
            
        }
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        buttonView.backgroundColor = UIColor.white
        self.parentViewController?.dismiss(animated: true)
    }
}
