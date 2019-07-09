//
//  DriverInfoPageViewController.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 02/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

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
