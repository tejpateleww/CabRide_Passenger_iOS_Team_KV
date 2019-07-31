//
//  BulkMileTableViewCell.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class BulkMileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnPurchase: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPriceRange: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
