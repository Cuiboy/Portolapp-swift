//
//  CalendarCollectionViewCell.swift
//  PHS App
//
//  Created by Patrick Cui on 8/21/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarCollectionViewCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dotView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
