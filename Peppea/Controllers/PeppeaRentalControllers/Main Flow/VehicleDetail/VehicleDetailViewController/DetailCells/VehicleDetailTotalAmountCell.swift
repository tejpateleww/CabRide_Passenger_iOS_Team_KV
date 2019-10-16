//
//  VehicleDetailTotalAmountCell.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit

class VehicleDetailTotalAmountCell: UITableViewCell {
@IBOutlet var viewCell: UIView!
    
    
    @IBOutlet var lblTotalAmount: UILabel!
    
    @IBOutlet weak var promocodeView: UIView!
    
    @IBOutlet weak var lblDiscountAmount: UILabel!
    
    @IBOutlet weak var noteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setUpUI() {
        
//        self.noteView.layer.cornerRadius = 8.0
//        self.noteView.layer.masksToBounds = true
//        
//        self.noteView.layer.borderWidth = 0.5
//        self.noteView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
