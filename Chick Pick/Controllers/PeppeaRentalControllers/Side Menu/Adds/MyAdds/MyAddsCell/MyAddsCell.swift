//
//  MyAddsCell.swift
//  Peppea
//
//  Created by EWW078 on 05/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class MyAddsCell: UITableViewCell {

    @IBOutlet var iconVehicle: UIImageView!
    
    @IBOutlet var viewCell: UIView!

    @IBOutlet var lblVehicleName: UILabel!
    
    @IBOutlet weak var ratePerKmLbl: UILabel!

    @IBOutlet weak var dutyOnLbl: UILabel!
    
    @IBOutlet var lblSeater: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func
        uiSetup(){
        
        ///Cell Border and Corener Radius
        self.viewCell.layer.borderWidth = 1.2
        self.viewCell.layer.borderColor = cellBorderColor.cgColor
        //        cell.viewCell.layer.cornerRadius = 9.0
        self.viewCell.layer.cornerRadius = 15
        self.viewCell.layer.masksToBounds = true
        
        
        //        cell.viewCell.backgroundColor = UIColor.white
        //        cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
        //        cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //        cell.viewCell.layer.shadowOpacity = 0.4
        //        cell.viewCell.layer.shadowRadius = 1
        
        
        
    }

}
