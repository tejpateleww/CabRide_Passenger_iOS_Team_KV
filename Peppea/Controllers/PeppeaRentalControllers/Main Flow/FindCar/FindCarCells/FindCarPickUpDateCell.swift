//
//  FindCarPickUpDateCell.swift
//  Peppea
//
//  Created by EWW078 on 30/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class FindCarPickUpDateCell: UITableViewCell {

    @IBOutlet weak var btnFindCar: UIButton!
    
    @IBOutlet weak var viewSelectLocation: UIView!
    @IBOutlet weak var lblAddressLocation: UILabel!
    
    @IBOutlet weak var viewPickUp: UIView!
    @IBOutlet weak var btnPickUpDate: UIButton!
    @IBOutlet weak var lblPickUpDate: UILabel!

    @IBOutlet weak var viewDropOff: UIView!
    @IBOutlet weak var lblDropOffDate: UILabel!
    @IBOutlet weak var btnDropOffDate: UIButton!
   
    var findCarButtonClickClosure: (() -> ())?
    
    var chooseLocationButtonClickClosure: (() -> ())?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpUI() {
        
        self.btnFindCar.layer.cornerRadius = 8.0
        self.btnFindCar.layer.masksToBounds = true
        
        self.viewPickUp.layer.cornerRadius = 8.0
        //Note: As we have added drop shaddow, not to change masks to bounds property
//        self.viewPickUp.layer.masksToBounds = true
        self.viewPickUp.layer.borderWidth = 1.6
        self.viewPickUp.layer.borderColor = UIColor.lightGray.cgColor
            //Add drop shaddow here

        self.viewDropOff.layer.cornerRadius = 8.0
        //Note: As we have added drop shaddow, not to change masks to bounds property
//        self.viewDropOff.layer.masksToBounds = true
        self.viewDropOff.layer.borderWidth = 1.6
        self.viewDropOff.layer.borderColor = UIColor.lightGray.cgColor
        //Add drop shaddow here

        
        self.viewSelectLocation.layer.cornerRadius = 8.0
        //Note: As we have added drop shaddow, not to change masks to bounds property

//        self.viewSelectLocation.layer.masksToBounds = true
        self.viewSelectLocation.layer.borderWidth = 1.6
        self.viewSelectLocation.layer.borderColor = UIColor.lightGray.cgColor
        //Add drop shaddow here
        
        
        
    }
    @IBAction private func findCarButtonClicked(_ sender: Any) {
        
        if let findCarButtonClickClosure = self.findCarButtonClickClosure {
            
            findCarButtonClickClosure()
        }
    
    }
  
    @IBAction private func chooseLocationButtonClick(_ sender: Any) {
        
        if let chooseLocationButtonClickClosure = self.chooseLocationButtonClickClosure {
            
            chooseLocationButtonClickClosure()
        }
        
    }
}
