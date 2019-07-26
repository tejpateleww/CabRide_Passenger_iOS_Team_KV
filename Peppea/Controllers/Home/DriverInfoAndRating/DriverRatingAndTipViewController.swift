//
//  DriverRatingAndTipViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 04/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class DriverRatingAndTipViewController: UIViewController {

    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var btnTip20: UIButton!
    @IBOutlet weak var btnTip30: UIButton!
    @IBOutlet weak var btnTip40: UIButton!

    @IBOutlet weak var btnDone: ThemeButton!
    @IBOutlet var btnTips: [UIButton]!
    
    var bookingId = ""
    var tip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setData(bookingData: BookingInfo) {
        
        bookingId = bookingData.id
        
        let driver = bookingData.driverInfo
        _ = bookingData.customerInfo
        let vehicleType = bookingData.vehicleType
        
        lblDriverName.text = "How was your trip with \((driver?.firstName ?? "") + " " + (driver?.lastName ?? ""))?"
        
        let base = NetworkEnvironment.baseImageURL
        
        imgDriverImage.sd_setImage(with: URL(string: base + driver!.profileImage), completed: nil)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for (ind,btn) in self.btnTips.enumerated()
        {
            btn.borderWidth = 1.0
            btn.borderColor = ThemeColor
            btn.layer.cornerRadius = btn.frame.size.width/2
            btn.layer.masksToBounds = true
            btn.titleLabel?.font = UIFont.regular(ofSize: 12)
            btn.setTitleColor(ThemeColor, for: .normal)
            
            btn.tag = ind
            btn.addTarget(self, action: #selector(self.tipAction(_:)), for: .touchUpInside)
        }
    }

    func setupView()
    {
        viewRating.settings.filledImage = UIImage(named: "iconSelectedstar")
        viewRating.settings.emptyImage = UIImage(named: "iconUnSelectedstar")
        viewRating.settings.starSize = 30
        viewRating.settings.starMargin = 5
    }

    @objc func tipAction(_ sender: UIButton) {
        
        let value = sender.titleLabel?.text?.replacingOccurrences(of: "K ", with: "")
        tip = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    @IBAction func btnDone(_ sender: Any) {
        
//        let alert = UIAlertController(title: AppName.kAPPName, message: "Your trip has been completed", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "OK", style: .default) { (action) in

            let homeVC = self.parent as? HomeViewController
//            homeVC?.containerView.isHidden = true
//            homeVC?.viewPickupLocation.isHidden = true
//            homeVC?.hideBookLaterButtonFromDroplocationField = false

            homeVC?.emitSocket_ReceiveTips(param: ["booking_id": self.bookingId, "tips": self.tip]) // booking_id,tips
//            homeVC?.setupAfterComplete()
//        }
//        alert.addAction(ok)
//        self.present(alert, animated: true, completion: nil)
    }


    

}
