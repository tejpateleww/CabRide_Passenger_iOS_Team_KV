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
    
    var PickupDisplayDate:String = ""
    var selectedPickupTime:String = ""
    var pickTimeToDisplay: String = ""
    
    var DeliveryDisplayDate:String = ""
    var selectedDeliveryTime:String = ""
    var deliveryTimeToDisplay: String = ""
    
    var isBookingFromBanner:Bool = false
    var BannerDetail:[String:AnyObject] = [:]
    
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.navigationController?.navigationBar.isTranslucent = false
        //TODO:
        //        parallaxEffect = RKParallaxEffect(tableView: tblView)
//        parallaxEffect.isParallaxEffectEnabled = true
//        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = false
//        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        ///TODO:
        //        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "Search For \(VehicalName)", leftImage: kBack_Icon, rightImage: "", isTranslucent: true)
//        self.btnFindVehicles.setTitle("Find \(VehicalName)", for: .normal)
        
        self.setNavBarWithMenu(Title: "", IsNeedRightButton: false)
        
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            cell.setUpUI()
            
            cell.btnPickUpDate.addTarget(self, action: #selector(self.btnPickupTime(_:)), for: .touchUpInside)
            
            
            if self.PickupDisplayDate == "" {
            
                cell.lblPickUpDate.text = "Pickup Date & Time"
                
            }else {
                 cell.lblPickUpDate.text = self.PickupDisplayDate
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
        
        
        
        
        //        var customCell = UITableViewCell()
        //
        //        if indexPath.row == 0
        //        {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "SerchForVehicleFirstCell") as! SerchForVehicleFirstCell
        
        
        //            cell.viewCell.backgroundColor = UIColor.white
        //            cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
        //            cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //            cell.viewCell.layer.shadowOpacity = 0.4
        //            cell.viewCell.layer.shadowRadius = 1
        //
        //            cell.viewCell.layer.cornerRadius = 10
        //
        //            cell.layer.zPosition = (indexPath.row == 0) ? 1 : 0
        //
        //            customCell = cell
        //        }
        //        else
        //        {
//        var CustomCell = UITableViewCell()
//        if arrOfferList.count > 0 {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FindCarOfferListCell") as! FindCarOfferListCell
//
//        //        cell.viewCell.layer.cornerRadius = 10
//        //        cell.viewCell.layer.borderWidth = 1
//        //        cell.viewCell.layer.borderColor = UIColor.lightGray.cgColor
//
//
//        cell.viewCEll.backgroundColor = UIColor.white
//        cell.viewCEll.layer.shadowColor = UIColor.darkGray.cgColor
//        cell.viewCEll.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        cell.viewCEll.layer.shadowOpacity = 0.4
//        cell.viewCEll.layer.shadowRadius = 1
//
//        cell.viewCEll.layer.cornerRadius = 10
//
//        if let img =  arrOfferList[indexPath.row]["image"] as? String  {
//
//            //Swift 5
////            cell.imgOfferBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
////            cell.imgOfferBanner.sd_setImage(with: URL(string: "\(WebserviceURLs.kOfferImageBaseURL)\(img)"))
//
//            //            cell.imgOfferBanner.sd_s
////            cell.imgOfferBanner.sd_setIndicatorStyle(.gray)
////            cell.imgOfferBanner.sd_setImage(with: URL(string:"\(WebserviceURLs.kOfferImageBaseURL)\(img)")!)
//        }
//            CustomCell = cell
//        }
//        else {
//            let NoDataCell = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! UITableViewCell
//
//            CustomCell = NoDataCell
//        }
//
//        CustomCell.selectionStyle = .none
//        //        cell.viewCell.layer.masksToBounds = true
//
//
//        //        cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
//        //        cellMenu.selectionStyle = .none
//        //
//        //        cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
//
//        //            customCell = cell
//        //        }
//        return CustomCell
//
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
            return 253.0

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
        let NavSelect = UINavigationController(rootViewController: selectDateTime)
        self.present(NavSelect, animated: true, completion: nil)

    }
    
    @IBAction func btnDropOffTime(_ sender: Any) {
        
        ///TODO:

//        let selectDateTime = self.storyboard?.instantiateViewController(withIdentifier: "SelectDateTimeViewController") as! SelectDateTimeViewController
//        selectDateTime.Delegate = self
//        selectDateTime.TypeofSelection = "END"
//        let NavSelect = UINavigationController(rootViewController: selectDateTime)
//        self.present(NavSelect, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func btnSelectYourLocationClicked(_ sender: Any)
    {
        ///TODO:
//        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchYourLocationViewController") as! SearchYourLocationViewController
//        viewController.Delegate = self
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnFindCars(_ sender: Any) {
        
        ///TODO:
//        let validator = self.isValidate()
//
//        if validator.0 == true  {
//            if isBookingFromBanner == false {
//                let vehicalList = self.storyboard?.instantiateViewController(withIdentifier: "SelectVehicleViewController") as! SelectVehicleViewController
//                vehicalList.startDate = "\(self.selectedPickupTime):00"
//                vehicalList.endDate = "\(self.selectedDeliveryTime):00"
//                vehicalList.VehicalCat_IDName = (Vehical_ID,VehicalName)
//                vehicalList.selectedAddress = self.selectedAddress
//                vehicalList.selectedAddLat = self.selectedAddLat
//                vehicalList.selectedAddLong = self.selectedAddLong
//                vehicalList.selectedTripType = self.selectedLocationType
//                vehicalList.DisplayPickupDate = self.PickupDisplayDate
//                vehicalList.DisplayDeliveryDate = self.DeliveryDisplayDate
//                self.navigationController?.pushViewController(vehicalList, animated: true)
//            }
//            else if isBookingFromBanner == true {
//                let vehicleDetail = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailViewController") as! VehicleDetailViewController
//                vehicleDetail.VehicleDetail = self.BannerDetail
//                vehicleDetail.vehicleFrom_To = ("\(self.selectedPickupTime):00","\(self.selectedDeliveryTime):00")
//                vehicleDetail.startDisplayDate = self.PickupDisplayDate
//                vehicleDetail.endDisplayDate = self.DeliveryDisplayDate
//                vehicleDetail.selectedAddress = self.selectedAddress
//                vehicleDetail.selectedAddLat = self.selectedAddLat
//                vehicleDetail.selectedAddLong = self.selectedAddLong
//                vehicleDetail.selectedTripType = self.selectedLocationType
//                self.navigationController?.pushViewController(vehicleDetail, animated: true)
//            }
//
//        } else {
//            Utilities.showToastMSG(MSG: validator.1)
//        }
//
    }
    
    //MARK:- LocationSelectionDelegate Method
    
    func SelectionLocationDelegate(SelectedLocation: CLLocation?, AddressString: String, LocationType:String) {
        self.selectedAddLat = (SelectedLocation?.coordinate.latitude)!
        self.selectedAddLong = (SelectedLocation?.coordinate.longitude)!
        self.selectedAddress = AddressString
//        self.lblStartingPoint.text = self.selectedAddress
        self.selectedLocationType = LocationType
    }
    
    //MARK:- selectDateDelegate Methods
    
//    func DidSelectStartTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {
////        self.lblPickupTime.text = DisplayAmPmFormat
//        ///TODO:
////        self.selectedPickupTime = HoursFormat
////        self.PickupDisplayDate = "\(HoursFormat):00".Convert_To_dd_MMM_yyyy_HH_mm_a()
//    }
//    
//    func DidSelectEndTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {
////        self.lblDropOffTime.text = DisplayAmPmFormat
//        ///TODO:
////        self.selectedDeliveryTime = HoursFormat
////        self.DeliveryDisplayDate = "\(HoursFormat):00".Convert_To_dd_MMM_yyyy_HH_mm_a()
//    }
    
    //    func DidSelectEndTripDate(SelectedDate: String, HoursFormat: String) {
    //        self.lblDropOffTime.text = SelectedDate
    //        self.selectedDeliveryTime = HoursFormat
    //    }
    //
    //    func DidSelectStartTripDate(SelectedDate: String, HoursFormat: String) {
    //        self.lblPickupTime.text = SelectedDate
    //        self.selectedPickupTime = SelectedDate
    //    }
    
    //    func DidSelectEndTripDate(SelectedDate: String) {
    //        self.lblDropOffTime.text = SelectedDate
    //        self.selectedDeliveryTime = SelectedDate
    //    }
    //
    //    func DidSelectStartTripDate(SelectedDate: String) {
    //        self.lblPickupTime.text = SelectedDate
    //        self.selectedPickupTime = SelectedDate
    //    }
    
}

extension FindCarViewController: SelectDateDelegate {
    
    
    //MARK:- selectDateDelegate Methods
    
    func DidSelectStartTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {

        self.pickTimeToDisplay = DisplayAmPmFormat
        self.selectedPickupTime = HoursFormat
        self.PickupDisplayDate = "\(HoursFormat):00".Convert_To_dd_MMM_yyyy_HH_mm_a()
        
        //For updating the values
        self.tblView.reloadData()
    }
    
    func DidSelectEndTripDate(SelectedDate: String, HoursFormat: String, DisplayAmPmFormat: String) {
//        self.lblDropOffTime.text = DisplayAmPmFormat
        self.selectedDeliveryTime = HoursFormat
//        self.DeliveryDisplayDate = "\(HoursFormat):00".Convert_To_dd_MMM_yyyy_HH_mm_a()
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
