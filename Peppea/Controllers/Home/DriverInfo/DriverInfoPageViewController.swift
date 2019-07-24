//
//  DriverInfoPageViewController.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 02/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class DriverInfoPageViewController: UIViewController {

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var imgDestinationIcon: UIImageView!
    @IBOutlet weak var lblCareName: UILabel!
    @IBOutlet weak var lblCarPlateNumber: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblEstimatedFare: UILabel!
    @IBOutlet weak var lblEstimatedFareTitle: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var viewWaiting: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblDriverName: UILabel!
    

    func setData(bookingData: BookingInfo) {
        //        booingInfo
        
        let driver = bookingData.driverInfo
        _ = bookingData.customerInfo
        let vehicleType = bookingData.vehicleType
        
        let esti = Int(bookingData.estimatedFare)
        
        lblCareName.text = vehicleType?.name
//        lblCarPlateNumber.text = vehicleType.
        lblPickupLocation.text = bookingData.pickupLocation
        lblDropoffLocation.text = bookingData.dropoffLocation
        lblEstimatedFare.text = "\(Currency)\((esti ?? 0) - 10) - \(Currency)\((esti ?? 0) + 10)"
        lblDriverName.text = driver?.firstName
        
        let base = NetworkEnvironment.baseImageURL
        
//        imgDriver.sd_addActivityIndicator()
//        imgDriver.sd_setShowActivityIndicatorView(true)
//        imgDriver.sd_setIndicatorStyle(.gray)
        imgDriver.sd_setImage(with: URL(string: base + driver!.profileImage), completed: nil)
        imgCar.sd_setImage(with: URL(string: base + vehicleType!.image), completed: nil)
        
    }
    
    var driverInfo = NSDictionary()
    var CarModelInfo = NSDictionary()
    var strCarImage = String()
    var strCareName = String()
    var strCarClass = String()
    var strEstimateFare = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var strDriverImage = String()
    var strDriverName = String()
    var strCarPlateNumber = String()
    var strPassengerMobileNumber = String()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        imgDestinationIcon.tintColor = ThemeColor
    }
    @IBAction func btnMessage(_ sender: Any) {
    }

    @IBAction func btnCall(_ sender: Any) {
    }

    @IBAction func btnCancel(_ sender: Any) {
        let homeVC = self.parent as? HomeViewController
        homeVC?.hideAndShowView(view: .waiting)
       
    }
    @IBAction func btnWaitingTime(_ sender: Any) {
        let homeVC = self.parent as? HomeViewController
        homeVC?.hideAndShowView(view: .ratings)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
