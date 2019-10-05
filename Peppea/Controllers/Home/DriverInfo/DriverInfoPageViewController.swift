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
        
        let esti = Int(Double(bookingData.estimatedFare) ?? 0)
        
        lblCareName.text = vehicleType?.name
//        lblCarPlateNumber.text = vehicleType.
        lblPickupLocation.text = bookingData.pickupLocation
        lblDropoffLocation.text = bookingData.dropoffLocation
        lblEstimatedFare.text = "\(Currency)\((esti) - 10) - \(Currency)\((esti) + 10)"
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
    var OpenChatBox:(() -> ())?
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        imgDestinationIcon.tintColor = ThemeColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgDriver.layer.borderWidth = 1
        imgDriver.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imgDriver.layer.cornerRadius = imgDriver.frame.width / 2
        imgDriver.layer.masksToBounds = true
    }
    
    @IBAction func btnMessage(_ sender: Any) {
        if let OpenChatAction = OpenChatBox {
            OpenChatAction()
        }
    }

    @IBAction func btnCall(_ sender: Any) {
    }

    @IBAction func btnCancel(_ sender: Any) {
//        let homeVC = self.parent as? HomeViewController
//  //      homeVC?.hideAndShowView(view: .waiting)
//        homeVC?.setupAfterComplete()
        let AlertController = UIAlertController(title:AppName.kAPPName , message: "Are you sure want to cancel the trip?", preferredStyle: .alert)
        AlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self.webserviceForCancelTrip()
        }))
        AlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        guard let Parentvc = self.parent as? HomeViewController else { return }
        Parentvc.present(AlertController, animated: true, completion: nil)
    }
    
    @IBAction func btnWaitingTime(_ sender: Any) {
        let homeVC = self.parent as? HomeViewController
        homeVC?.hideAndShowView(view: .ratings)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    func webserviceForCancelTrip() {
        
        let homeVC = self.parent as? HomeViewController
        
        let model = CancelTripRequestModel()
        model.booking_id = homeVC?.booingInfo.id ?? ""
        UserWebserviceSubclass.CancelTripBookingRequest(bookingRequestModel: model) { (response, status) in
            
            if status {
                  homeVC?.setupAfterComplete()
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.stringValue ?? "Something went wrong")
            }
        }
    }
    
    
}
