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
    @IBOutlet weak var stackViewOther: UIStackView!
    @IBOutlet weak var txtOther: UITextField!
    
    @IBOutlet weak var txtComments: UITextField!
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet weak var viewAskForTip: UIView!
    
    
    var bookingId = ""
    var tip = ""
    var myRating: Double = 0
    
    var viewType: HomeViews?
    
    var isOtherSelected: Bool = false {
        didSet {
            if isOtherSelected {
                stackViewOther.isHidden = false
            } else {
                stackViewOther.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setData(bookingData: BookingInfo) {
        
        bookingId = bookingData.id
        
        let driver = bookingData.driverInfo
        _ = bookingData.customerInfo
        _ = bookingData.vehicleType
        
        
        if viewType == .ratings {
            viewAskForTip.isHidden = true
            lblDriverName.text = "How was your trip with \((driver?.firstName ?? "") + " " + (driver?.lastName ?? ""))?"
        }
        else if viewType == .askForTip {
            viewComments.isHidden = true
            viewRating.isHidden = true
            lblDriverName.text = "Do you want to tip \((driver?.firstName ?? "") + " " + (driver?.lastName ?? ""))?"
        }
        
//        lblDriverName.text = "How was your trip with \((driver?.firstName ?? "") + " " + (driver?.lastName ?? ""))?"
        
        let base = NetworkEnvironment.baseImageURL
        
        imgDriverImage.sd_setImage(with: URL(string: base + driver!.profileImage), completed: nil)
        
        viewRating.didFinishTouchingCosmos = { rating in
            self.myRating = rating
        }
        
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
        isOtherSelected = false
        let value = sender.titleLabel?.text?.replacingOccurrences(of: "K ", with: "")
        tip = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    @IBAction func btnOtherAction(_ sender: UIButton) {
        isOtherSelected = true
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        if viewType == .ratings {
            webserviceForReviewRating()
        }
        else if viewType == .askForTip {
            let homeVC = self.parent as? HomeViewController
            homeVC?.emitSocket_ReceiveTips(param: ["booking_id": self.bookingId, "tips": isOtherSelected ? (txtOther.text ?? "") : self.tip])
        }
        
////        let alert = UIAlertController(title: AppName.kAPPName, message: "Your trip has been completed", preferredStyle: .alert)
////        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
//
//            let homeVC = self.parent as? HomeViewController
////            homeVC?.containerView.isHidden = true
////            homeVC?.viewPickupLocation.isHidden = true
////            homeVC?.hideBookLaterButtonFromDroplocationField = false
//
//        homeVC?.emitSocket_ReceiveTips(param: ["booking_id": self.bookingId, "tips": isOtherSelected ? (txtOther.text ?? "") : self.tip]) // booking_id,tips
////            homeVC?.setupAfterComplete()
////        }
////        alert.addAction(ok)
////        self.present(alert, animated: true, completion: nil)
    }

    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceForReviewRating() {
        
        let model = ReviewRatingReqModel()
        model.booking_id = SingletonClass.sharedInstance.loginData.id ?? ""
        model.rating = "\(myRating)"
        model.comment = txtComments.text ?? ""
        
        UserWebserviceSubclass.ReviewRatingToDriver(bookingRequestModel: model) { (response, status) in
            
            if status {
                AlertMessage.showMessageForSuccess(response.dictionary?["message"]?.stringValue ?? "")
                
                let alert = UIAlertController(title: AppName.kAPPName, message: "Your trip has been completed", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    let homeVC = self.parent as? HomeViewController
                    homeVC?.setupAfterComplete()
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.stringValue ?? "")
            }
        }
        
    }
}
