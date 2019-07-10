//
//  FlatRateViewCell.swift
//  TESLUXE
//
//  Created by Excellent WebWorld on 24/09/18.
//  Copyright © 2018 Excellent WebWorld. All rights reserved.
//

import UIKit

class FlatRateViewCell: UITableViewCell {

    
    @IBOutlet var lblPickupLocation: UILabel!
     @IBOutlet var lblDropOffLocation: UILabel!
    @IBOutlet var viewCell: UIView!
    
    @IBOutlet var viewAddress: UIView!
    @IBOutlet var viewPrice: UIView!
    
    @IBOutlet var btnPrice: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
