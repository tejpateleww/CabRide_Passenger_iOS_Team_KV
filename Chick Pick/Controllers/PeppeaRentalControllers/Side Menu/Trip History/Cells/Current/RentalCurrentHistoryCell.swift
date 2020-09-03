//
//  MyTripTableViewCell.swift
//  Chick Pick
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import Cosmos

class RentalCurrentHistoryCell: UITableViewCell {
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDropoff: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBookin: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet var lblKM: UILabel!
    
    @IBOutlet weak var lblVehicleNo: UILabel!
    @IBOutlet weak var btnSendReceipt: UIButton!
    @IBOutlet weak var btnTripProceed: UIButton!
    @IBOutlet weak var ratingsView: CosmosView!
    
    override func draw(_ rect: CGRect) {
        setup()	
    }
    
    func setup(){
        selectionStyle = .none
        
        self.cellContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.cellContainerView.layer.borderWidth =  1.0
        
        self.cellContainerView.layer.cornerRadius = 5.0
        self.cellContainerView.layer.masksToBounds = true
        
//        cellContainerView.roundCorners([.topLeft,.topRight], radius: 5)

        btnTripProceed.roundCorners([.bottomLeft,.bottomRight], radius: 20.0)
        
      
        
        
//        btnSendReceipt.layer.borderColor = UIColor.white.cgColor
//        btnSendReceipt.layer.borderWidth = 1.5
//        btnSendReceipt.clipsToBounds = true
    }
}
