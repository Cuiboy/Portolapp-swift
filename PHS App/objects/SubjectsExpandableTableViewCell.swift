//
//  SubjectsExpandableTableViewCell.swift
//  PHS App
//
//  Created by Patrick Cui on 8/17/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import UIKit
import ExpandableCell

class SubjectsExpandableTableViewCell: ExpandableCell {

    @IBOutlet weak var subjectLabel: UILabel!
    static let ID = "expandableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
