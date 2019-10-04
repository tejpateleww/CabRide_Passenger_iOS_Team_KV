//
//  VehiclePaymentBreakdownCell.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//



import UIKit

protocol TryPromoCodeDelegate {
    func didTestPromoCode(Promocode:String)
    func didRemovePromoCode()
    func didChangePromoCode(Promocode:String)
}

class VehiclePaymentBreakdownCell: UITableViewCell {

    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblRefundableDeposit: UILabel!
    @IBOutlet var btnOffers: UIButton!
    @IBOutlet var lblFarePriceKM: UILabel!
    @IBOutlet weak var PromoView: UIView!
    @IBOutlet weak var txtHavePromoCode: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var btnRemovePromocode: UIButton!
    @IBOutlet weak var imgVerified: UIImageView!
    
    @IBOutlet weak var lblSpecialFare: UILabel!
    @IBOutlet weak var lblDeliveryFare: UILabel!
    @IBOutlet var lblTaxAmount: UILabel!
    
    
    @IBOutlet var ViewTaxFare: UIView!
    @IBOutlet weak var ViewSpecialFare: UIView!
    @IBOutlet weak var ViewDeliveryFare: UIView!
    
    @IBOutlet weak var btnViewOffers: UIButton!
    
    
    var Delegate:TryPromoCodeDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func txtDidValueChange(_ sender: Any) {
        self.Delegate.didChangePromoCode(Promocode: self.txtHavePromoCode.text!)
    }
//
    
    
    //IBAction Methods
    
    @IBAction func btnApplyAction(_ sender: Any) {
       
        self.contentView.endEditing(true)
        self.Delegate.didTestPromoCode(Promocode: self.txtHavePromoCode.text!)
    
    }
    
    
    @IBAction func btnRemovePromoCode(_ sender: Any) {
        self.contentView.endEditing(true)
        self.txtHavePromoCode.text = ""
        self.imgVerified.isHidden = true
        self.btnRemovePromocode.isHidden = true
        self.Delegate.didRemovePromoCode()
    }

}

