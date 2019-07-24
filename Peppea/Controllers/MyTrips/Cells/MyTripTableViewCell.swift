//
//  MyTripTableViewCell.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class MyTripTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDropoff: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBookin: UILabel!
    @IBOutlet weak var lblDate: UILabel!
   
    @IBOutlet weak var btnSendReceipt: UIButton!

    override func draw(_ rect: CGRect) {
        setup()
    }
    
    func setup(){
        selectionStyle = .none
        cellContainerView.roundCorners([.topLeft,.topRight], radius: 5)
//        btnSendReceipt.layer.cornerRadius = 15
//        btnSendReceipt.layer.borderColor = UIColor.white.cgColor
//        btnSendReceipt.layer.borderWidth = 1.5
//        btnSendReceipt.clipsToBounds = true
    }
}
