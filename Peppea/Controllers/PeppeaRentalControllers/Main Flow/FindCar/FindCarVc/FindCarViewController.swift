//
//  SearchForVehicleViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage
import GooglePlaces

class FindCarViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
    ///TODO:
    //SelectDateDelegate, LocationSelectionDelegate
{
    
    
//    @IBOutlet var viewHeader: UIView!
    @IBOutlet var tblView: UITableView!
    
//    @IBOutlet var viewDropoff: UIView!
//    @IBOutlet var vioewPickup: UIView!
//    @IBOutlet var viewTimeBTNS: UIView!
//    @IBOutlet var btnDropOffTime: UIButton!
//    @IBOutlet var btnPickupTime: UIButton!
//    @IBOutlet var viewSelectedPoint: UIView!
//    @IBOutlet weak var lblPickupTime: UILabel!
//    @IBOutlet weak var lblDropOffTime: UILabel!
//    @IBOutlet weak var lblStartingPoint: UILabel!
    @IBOutlet weak var btnFindVehicles: UIButton!
    
    
    
    var arrVehicles:[[String:Any]] = []
    var arrOfferList :[[String:Any]] = []
//    var parallaxEffect: RKParallaxEffect!
    var VehicalName:String = ""
    var VehicalImage:UIImage = UIImage()
    var VehicalIcon:String = ""
    var Vehical_ID:String = ""
    var selectedAddress:String = ""
    var selectedAddLat = Double()
    var selectedAddLong = Double()
    
    
    var selectedLocationType:String = ""
    
    var selectedPlace: GMSPlace?
    
    var pickUpDateToDisplay:String = ""
    var selectedPickupDate:String = ""
    
    var dropOffDateToDisplay:String = ""
    var selectedDropOffDate:String = ""
    
    var isBookingFromBanner:Bool = false
    var BannerDetail:[String:AnyObject] = [:]
    
    @IBOutlet weak var topConstraintContainerView: NSLayoutConstraint!
    
    var topBarHeight: CGFloat = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
//        viewSelectedPoint.layer.cornerRadius = 10 //viewSelectedPoint.frame.height/2
//        viewSelectedPoint.layer.masksToBounds = true
//        //        viewTimeBTNS.layer.cornerRadius = 10
//        //        viewTimeBTNS.layer.masksToBounds = true
//        vioewPickup.layer.cornerRadius = 5
//        vioewPickup.layer.masksToBounds = true
//        viewDropoff.layer.cornerRadius = 5
//        viewDropoff.layer.masksToBounds = true
        
        //TODO:
        //        self.iconVehicle.sd_setShowActivityIndicatorView(true)
//        self.iconVehicle.sd_setIndicatorStyle(.gray)
//        self.iconVehicle.sd_setImage(with: URL.init(string: VehicalIcon), placeholderImage: UIImage.init(named: ""), completed: nil)
//        self.webserviceForGetOffers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Set navigation bar
        self.setNavBarWithMenu(Title: "", IsNeedRightButton: false)
        ///Note: For setting left ar button item's color to white
        self.navigationController?.navigationBar.tintColor = .white

        
        ///Stretching Top constraint of a Top View.
        let navigationbarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        let StatusBarHeight = UIApplication.shared.statusBarFrame.height
        topBarHeight = navigationbarHeight + StatusBarHeight
        self.topConstraintContainerView.constant = 0 - topBarHeight
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.navigationController?.navigationBar.isTranslucent = false
        //TODO:
        //        parallaxEffect = RKParallaxEffect(tableView: tblView)
//        parallaxEffect.isParallaxEffectEnabled = true
//        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = false
//        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = false
    }
    
    
 
    
    
    func isValidate() -> (Bool,String) {
        
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.selectedPlace == nil {
            ValidatorMessage = "Please select start point location."
            isValid = false
        }
        else if self.selectedPickupDate == "" {
            ValidatorMessage = "Please select pick up date and time."
            isValid = false
        }else if self.selectedDropOffDate == "" {
            ValidatorMessage = "Please select drop off date and time."
            isValid = false
        }
        
        return (isValid,ValidatorMessage)
    }

    //MARK : - TableView Method -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
            //arrOfferList.count > 0 ? arrOfferList.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if indexPath.row == 0 {
         
            //Header Cell
              let cell = tableView.dequeueReusableCell(withIdentifier: "FindCarHeaderCell") as! FindCarHeaderCell
              return cell
            

        }
        else if indexPath.row == 1 {
            
            //Select Date Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FindCarPickUpDateCell") as! FindCarPickUpDateCell
           
            //1. Set Up UI
            cell.setUpUI()
            
            //2. Button Click events
            cell.chooseLocationButtonClickClosure = {
                
                
                self.openGooglePlacePicker()
                
            }
            cell.btnPickUpDate.addTarget(self, action: #selector(self.btnPickupTime(_:)), for: .touchUpInside)
            cell.btnDropOffDate.addTarget(self, action: #selector(self.btnDropOffTime(_:)), for: .touchUpInside)


            ///3 . Display Location, Pick Up and Drop Off Time
            
                    ///3.1 Location
                    if let selectedPlace = self.selectedPlace {
                   
                        cell.lblAddressLocation.text = selectedPlace.formattedAddress ?? ""
                        
                    }else{
                    
                        cell.lblAddressLocation.text = "Tell Us Your Starting Point"
                    }
            
                    ///3.2 Pick Up Date Label
                    if self.pickUpDateToDisplay == "" {
                    
                        cell.lblPickUpDate.text = "Pickup Date  & Time"
                        
                    }else {
                         cell.lblPickUpDate.text = self.pickUpDateToDisplay
                    }

                    ///3.3 Drop Off Date Label
                    if self.dropOffDateToDisplay == "" {
                        
                        cell.lblDropOffDate.text = "Drop Off Date & Time"
                        
                    }else {
                        cell.lblDropOffDate.text = self.dropOffDateToDisplay
                    }

            
            ///4. Find Car button Clicked
                    cell.findCarButtonClickClosure = {

                        let (isValid, message) = self.isValidate()
                        
                        if isValid {

                            let selectVehicleViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectVehicleViewController") as! SelectVehicleViewController
                            
                            selectVehicleViewController.placeSelected = self.selectedPlace
                            selectVehicleViewController.selectedPickUpDateString = self.selectedPickupDate
                            selectVehicleViewController.selectedDropOffDateString = self.selectedDropOffDate
                            
                            self.navigationController?.pushViewController(selectVehicleViewController, animated: true)
                            
                        }else{
                            
                            AlertMessage.showMessageForError(message)

                        }
                    
                    }
            
          

            
            return cell
            
            
        }else if indexPath.row == 2 {
         
            //Refer and earn cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FindCarReferAndEarnCell") as! FindCarReferAndEarnCell
            
            cell.setUpUI()
            
            return cell
            
        }else{

            //Trending Cars Collection Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FindCarTrendingCarsCell") as! FindCarTrendingCarsCell
            
            cell.collectionView.reloadData()
            
            return cell

        }
        
        
        
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        tableView.deselectRow(at: indexPath, animated: false)
        
//        tblView.deselectRow(at: indexPath, animated: true)
        //        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "VehicleEditViewController") as! VehicleEditViewController
        //        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.row  == 0 {
            //Header Image View
            return topBarHeight + 253.0

        }else if indexPath.row == 1 {
         
            //Select date
            return 215.0
        }
        else if indexPath.row == 2 {
            //Refer and Earn Cell
            return 164.0
        }
        else if indexPath.row == 3 {
            //Find cars Collection View
            return 168.0
        }

        return 0.0
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func btnPickupTime(_ sender: Any) {
        ///TODO:
        let selectDateTime = self.storyboard?.instantiateViewController(withIdentifier: "SelectDateTimeViewController") as! SelectDateTimeViewController
        selectDateTime.Delegate = self
        selectDateTime.TypeofSelection = "PICKUP"
        selectDateTime.isForPickUp = true
        
        
        //Data to Pass
        selectDateTime.selectedPickUpDateString = self.selectedPickupDate
        selectDateTime.selectedDropOffdateString = self.selectedDropOffDate
        
        let NavSelect = UINavigationController(rootViewController: selectDateTime)
        self.present(NavSelect, animated: true, completion: nil)

    }
    
    @IBAction func btnDropOffTime(_ sender: Any) {

        let selectDateTime = self.storyboard?.instantiateViewController(withIdentifier: "SelectDateTimeViewController") as! SelectDateTimeViewController
        selectDateTime.Delegate = self
        selectDateTime.TypeofSelection = "DROPOFF"
        selectDateTime.isForPickUp = false
        
        //Data to Pass
        selectDateTime.selectedPickUpDateString = self.selectedPickupDate
        selectDateTime.selectedDropOffdateString = self.selectedDropOffDate

        let NavSelect = UINavigationController(rootViewController: selectDateTime)
        self.present(NavSelect, animated: true, completion: nil)
        
    }
    
   
    //MARK:- LocationSelectionDelegate Method
    
    func SelectionLocationDelegate(SelectedLocation: CLLocation?, AddressString: String, LocationType:String) {
        self.selectedAddLat = (SelectedLocation?.coordinate.latitude)!
        self.selectedAddLong = (SelectedLocation?.coordinate.longitude)!
        self.selectedAddress = AddressString
//        self.lblStartingPoint.text = self.selectedAddress
        self.selectedLocationType = LocationType
    }
}

extension FindCarViewController: SelectDateDelegate {
    
    
    //MARK:- selectDateDelegate Methods
    
    /*
     - Selecteddate: "2019-10-14 5:30"
     - HoursFormat: "2019-10-14 17:30"
     - DisplayAmPmFormat : "2019-10-14 5:30 PM"
     */
    func DidSelectStartTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {

//        self.pickTimeToDisplay = DisplayAmPmFormat
        self.selectedPickupDate = HoursFormat
        ///yyyy-MM-dd HH:mm
        ///24 hours format
        
        //To Display in cell
        self.pickUpDateToDisplay = "\(HoursFormat)".convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
        
        //For updating the values
        self.tblView.reloadData()
    }
    
    /*
     - Selecteddate: "2019-10-14 5:30"
     - HoursFormat: "2019-10-14 17:30"
     - DisplayAmPmFormat : "2019-10-14 5:30 PM"
    */
    func DidSelectEndTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {

//        self.dropOffTimeToDisplay = DisplayAmPmFormat
        self.selectedDropOffDate = HoursFormat
        ///yyyy-MM-dd HH:mm
        ///24 hours format
        
        //To Display in cell
        self.dropOffDateToDisplay = "\(HoursFormat)".convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
    
        self.tblView.reloadData()
    
    }

    
}

///TODO:
//MARK:- WebService & Custom Methods
/*
extension SearchForVehicleViewController {
    
    func webserviceFindVehicle(_ dictParam : [String:Any])
    {
        webserviceForFindVehicles(dictParam, showHUD: true) { (result, status) in
            if status
            {
                print(result)
                let arrVehicalList = result["data"] as! [[String : Any]]
                
                let vehicalList = self.storyboard?.instantiateViewController(withIdentifier: "SelectVehicleViewController") as! SelectVehicleViewController
                vehicalList.arrVehicles = arrVehicalList
                vehicalList.startDate = self.selectedPickupTime
                vehicalList.endDate = self.selectedDeliveryTime
                self.navigationController?.pushViewController(vehicalList, animated: true)
                
                //                    let SuccessAlert = UIAlertController(title: "Password Updated Successfully.", message: "", preferredStyle: .alert)
                //                    SuccessAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
                //                        self.navigationController?.popViewController(animated: true)
                //                    }))
                //                    self.present(SuccessAlert, animated: true, completion: nil)
                
            } else {
                print(result)
                if let ErrorMessages = (result as! NSDictionary).object(forKey: "error") as? [String] {
                    let strMSG = ErrorMessages[0]
                    Utilities.showAlert(appName, message: strMSG, vc: self)
                } else if let ErrorMessage = (result as! NSDictionary).object(forKey: "error") as? String {
                    let strMSG = ErrorMessage
                    Utilities.showAlert(appName, message: strMSG, vc: self)
                }
            }
        }
        
    }
    
    func webserviceForGetOffers() {
        let dictParam = [String:Any]()
        webserviceForGetAllOffers(dictParam as AnyObject) { (result, status) in
            if status {
                self.arrOfferList = result["data"] as! [[String : Any]]
                self.tblView.reloadData()
            } else {
                print(result)
                if let ErrorMessages = (result as! NSDictionary).object(forKey: "error") as? [String] {
                    let strMSG = ErrorMessages[0]
                    Utilities.showAlert(appName, message: strMSG, vc: self)
                } else if let ErrorMessage = (result as! NSDictionary).object(forKey: "error") as? String {
                    let strMSG = ErrorMessage
                    Utilities.showAlert(appName, message: strMSG, vc: self)
                }
            }
        }
    }
    
    func isValidate() -> (Bool,String) {
        
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.selectedAddress == "" {
            ValidatorMessage = "Please select your starting point."
            isValid = false
        } else if self.selectedPickupTime == "" {
            ValidatorMessage = "Please select pickup time."
            isValid = false
        } else if self.selectedDeliveryTime == "" {
            ValidatorMessage = "Please select dropoff time."
            isValid = false
        } else if self.isDateValid(fromDate:  "\(self.selectedPickupTime):00" , ToDate: "\(self.selectedDeliveryTime):00") == false {
            ValidatorMessage = "Please select dropoff time greater than pickup time."
            isValid = false
        }
        
        return (isValid,ValidatorMessage)
    }
    
    func isDateValid(fromDate:String,ToDate:String) -> Bool {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Fromdate = dateFormatter.date(from: fromDate)!
        let Enddate = dateFormatter.date(from: ToDate)!
        
        let Compare = Fromdate.compare(Enddate)
        
        return (Compare.rawValue == -1) ? true : false
    }
}
*/
