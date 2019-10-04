//
//  VehicleFirstTimeDurationCell.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit

class VehicleFirstTimeDurationCell: UITableViewCell {

    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var lblPickupTime: UILabel!
    @IBOutlet var lblDropoffTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
