//
//  HistoryTableViewCell.swift
//  Peppea
//
//  Created by eww090 on 10/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var lblBookingID: UILabel!
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblPaymentType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
