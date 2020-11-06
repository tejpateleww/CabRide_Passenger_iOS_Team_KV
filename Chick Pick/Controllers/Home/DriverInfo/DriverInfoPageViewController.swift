//
//  DriverInfoPageViewController.swift
//  Nexus User
//
//  Created by EWW-iMac Old on 02/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

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
    
    @IBOutlet weak var lblRating: UILabel!
    
    
    var contactNum = String()
    var reason = String()

    func setData(bookingData: BookingInfo) {
        //        booingInfo
        
        let driver = bookingData.driverInfo
        _ = bookingData.customerInfo
        let vehicleType = bookingData.vehicleType
        let driverVehicleType = bookingData.driverVehicleInfo
        
        let esti = Int(Double(bookingData.estimatedFare) ?? 0)
        
        lblCareName.text = vehicleType?.name
        lblCarPlateNumber.text = driverVehicleType?.plateNumber
        lblPickupLocation.text = bookingData.pickupLocation
        lblDropoffLocation.text = bookingData.dropoffLocation
//        lblEstimatedFare.text = "\(Currency)\((esti) - 10) - \(Currency)\((esti) + 10)"
        lblEstimatedFare.text = "\(Currency)\(esti)"
        lblDriverName.text = driver?.firstName
        lblRating.text = driver?.rating
        
        let base = NetworkEnvironment.baseImageURL
        contactNum = bookingData.driverInfo.mobileNo
        
//        imgDriver.sd_addActivityIndicator()
//        imgDriver.sd_setShowActivityIndicatorView(true)
//        imgDriver.sd_setIndicatorStyle(.gray)
        imgDriver.sd_setImage(with: URL(string: base + driver!.profileImage), placeholderImage: UIImage(named: "imgProfilePlaceHolder"))
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
        
        let contactNumber = contactNum
        if contactNumber == "" {
            UtilityClass.showAlert(title: AppName.kAPPName, message: "Contact number is not available", alertTheme: .error)
        }
        else {
            UtilityClass.callNumber(phoneNumber: contactNumber)
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
//        let homeVC = self.parent as? HomeViewController
//  //      homeVC?.hideAndShowView(view: .waiting)
//        homeVC?.setupAfterComplete()
        let AlertController = UIAlertController(title:AppName.kAPPName , message: "Are you sure want to cancel the trip?", preferredStyle: .alert)
        AlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
//            self.ReasonForCancelTheTrip()
            self.webserviceForCancellationCharges()
        }))
        AlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        guard let Parentvc = self.parent as? HomeViewController else { return }
        Parentvc.present(AlertController, animated: true, completion: nil)
    }
    
    func ReasonForCancelTheTrip(charges : String) {
        
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "CancelTripViewController") as? CancelTripViewController {
            vc.delegate = self
            vc.isDropDownHidden = true
            vc.isCancelReason = true
            vc.strDescription = "Dear Customer. To Keep Our Drivers Motivated. Please Note That Cancelling a Trip 3 Mins After Booking Attracts A Free of \(Currency)\(charges) Payable To The Driver. Please Confirm Whether You Still Wish To Cancel?"
            self.present(vc, animated: true, completion: nil)
        }
        
        
//        let AlertController2 = UIAlertController(title:AppName.kAPPName , message: "Reason for cancel the trip", preferredStyle: .actionSheet)
//        for item in SingletonClass.sharedInstance.cancelReason {
//            AlertController2.addAction(UIAlertAction(title: item.reason, style: .default, handler: { (UIAlertAction) in
//                self.reason = item.reason
//                self.webserviceForCancelTrip()
//            }))
//        }
//        AlertController2.addAction(UIAlertAction(title: "None of above", style: .cancel, handler: { (UIAlertAction) in
//            self.reason = ""
//            self.webserviceForCancelTrip()
//        }))
//        guard let Parentvc2 = self.parent as? HomeViewController else { return }
//        Parentvc2.present(AlertController2, animated: true, completion: nil)
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
    
    func webserviceForCancellationCharges() {
        UtilityClass.showHUD(with: self.parent?.view)
        
        let homeVC = self.parent as? HomeViewController
        let param = homeVC?.booingInfo.vehicleType.id ?? ""
        
        UserWebserviceSubclass.CancellationCharges(strURL: param) { (response, status) in
            //            print(response)
            UtilityClass.hideHUD()
           
            if(status) {
                let data = response["data"].dictionaryValue
                let charges = data["customer_cancellation_fee"]?.stringValue
                self.ReasonForCancelTheTrip(charges: charges ?? "")
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }

    func webserviceForCancelTrip() {
        
        let homeVC = self.parent as? HomeViewController
        
        let model = CancelTripRequestModel()
        model.booking_id = homeVC?.booingInfo.id ?? ""
        if reason != "" {
            model.cancele_reason = reason
        }
        UserWebserviceSubclass.CancelTripBookingRequest(bookingRequestModel: model) { (response, status) in
            
            if status {
                  homeVC?.setupAfterComplete()
            } else {
                AlertMessage.showMessageForError(response.dictionary?["message"]?.stringValue ?? "Something went wrong")
            }
        }
    }
}


extension DriverInfoPageViewController: delegateForCancelTripReason {
    
    func didCancelTripFromRider(obj: Any) {
        self.reason = ""
        if ((obj as? String) != nil) {
            self.reason = (obj as? String ?? "")
        }
        else if ((obj as? CancelReason) != nil) {
            self.reason = (obj as? CancelReason)?.reason ?? ""
        }
        
        self.webserviceForCancelTrip()
    }
}
