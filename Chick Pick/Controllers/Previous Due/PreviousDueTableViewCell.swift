//
//  PreviousDueTableViewCell.swift
//  Peppea
//
//  Created by EWW074 on 03/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit
import SwiftyJSON

class PreviousDueTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    
    @IBOutlet weak var lblPickTitle: UILabel!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    
    @IBOutlet weak var lblDropTitle: UILabel!
    @IBOutlet weak var lbDropOffLocation: UILabel!
    @IBOutlet weak var lblPreviousDue: UILabel!
    
    var notAvailable = "N/A"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnPay.setTitleColor(#colorLiteral(red: 0.9058823529, green: 0.5843137255, blue: 0.8745098039, alpha: 1), for: .normal)
        btnPay.imageView?.setImageColor(color: #colorLiteral(red: 0.9058823529, green: 0.5843137255, blue: 0.8745098039, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupData(object: PreviousDueModel) {
        
        lblBookingId.text = "Booking Id : \(object.bookingId ?? notAvailable)"
        lblPickUpLocation.text = object.pickupLocation
        lbDropOffLocation.text = object.dropoffLocation
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), .paragraphStyle: titleParagraphStyle]
        let attrString = NSMutableAttributedString(string: "Previous Due", attributes: myAttribute)
        let myAttribute2 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), .paragraphStyle: titleParagraphStyle]
        let attrString2 = NSMutableAttributedString(string: "\n\(Currency) \(object.amount ?? notAvailable)", attributes: myAttribute2)
       
        let str = NSMutableAttributedString(attributedString: attrString)
        str.append(attrString2)
        
        lblPreviousDue.attributedText = str
    }
}
