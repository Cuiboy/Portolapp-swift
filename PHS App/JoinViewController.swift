//
//  JoinViewController.swift
//  PHS App
//
//  Created by Patrick Cui on 10/2/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var invitedLabel: UILabel!
    @IBOutlet weak var information: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var joinButton: UIView!
    let joinLabel = UILabel()
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.joinButton.backgroundColor = UIColor.clear
        }
       
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        joinButton.layer.cornerRadius = joinButton.bounds.height / 2
        joinButton.layer.borderWidth = 1.5
        joinButton.layer.borderColor = UIColor.black.cgColor
        joinLabel.bounds = joinButton.bounds
        joinLabel.center = CGPoint(x: joinButton.bounds.width / 2, y: joinButton.bounds.height / 2)
        joinLabel.textAlignment = .center
        joinLabel.textColor = UIColor.black
        joinLabel.text = "TALK TO US!"
        joinLabel.font = UIFont(name: "Lato-Light", size: CGFloat(18).relativeToWidth)
        joinButton.addSubview(joinLabel)
        let joinGesture = UITapGestureRecognizer(target: self, action: #selector(joinTapped))
        joinGesture.delegate = self
        joinButton.addGestureRecognizer(joinGesture)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        invitedLabel.font = invitedLabel.font.withSize(invitedLabel.font.pointSize.relativeToWidth)
        
        information.font = information.font.withSize(information.font.pointSize.relativeToWidth.relativeToWidth)
        topConstraint.constant = topConstraint.constant.relativeToWidth
    }
    

    @objc func joinTapped() {
       
        UIView.animate(withDuration: 0.3, animations: {
              self.joinButton.backgroundColor = UIColor.lightGray
        }) { (_) in
             self.joinButton.backgroundColor = UIColor.clear
        }
        guard let url = URL(string: "https://forms.gle/TSarYRRYZ6pDjXVK6") else { return }
        UIApplication.shared.open(url)
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
