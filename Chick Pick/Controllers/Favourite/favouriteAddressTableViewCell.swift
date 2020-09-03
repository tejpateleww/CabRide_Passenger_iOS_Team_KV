//
//  favouriteAddressTableViewCell.swift
//  Peppea
//
//  Created by Apple on 05/08/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class favouriteAddressTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var imgAddressType: UIImageView!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddressDescription: UILabel!
    
}
