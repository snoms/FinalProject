//
//  journeyStepCell.swift
//  Trip
//
//  Created by bob on 09/06/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class journeyStepCell: UITableViewCell {
    
    
    @IBOutlet weak var stepTextView: UIView!
    
    @IBOutlet weak var stepTextfield: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}