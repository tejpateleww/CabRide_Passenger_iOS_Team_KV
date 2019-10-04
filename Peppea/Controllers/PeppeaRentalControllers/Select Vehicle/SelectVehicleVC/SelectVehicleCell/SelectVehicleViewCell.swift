//
//  SelectVehicleViewCell.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 13/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit

protocol BookVehicleDelegate {
    
    func didVehicleBook(CustomCell:UITableViewCell)
}


class SelectVehicleViewCell: UITableViewCell {

    
    @IBOutlet var iconVehicle: UIImageView!
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblSeater: UILabel!
    @IBOutlet var lblVehicleName: UILabel!
    
    var DelegateForVehicalBook:BookVehicleDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    @IBAction func btnBookAction(_ sender: Any) {
        self.DelegateForVehicalBook.didVehicleBook(CustomCell: self)
    }
    

}


extension SelectVehicleViewCell {
    
    
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
