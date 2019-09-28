//
//  SelectVehicleViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 13/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit

//CategoryFileterDelegate
class SelectVehicleViewController: BaseViewController,BookVehicleDelegate
{
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var lblEndDate: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var viewDateInterval: UIView!
    
    var selectedAddress:String = ""
    var selectedAddLat = Double()
    var selectedAddLong = Double()
    var selectedTripType:String = ""
    
    var VehicalCat_IDName:(String,String) = ("","")
    
    var FilterByModel:String = ""
    var FilterByType:String = ""
    
    var DisplayPickupDate:String = ""
    var DisplayDeliveryDate:String = ""
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var LoaderBackView: UIView!
    
    var arrVehicles:[[String:Any]] = []
    var startDate:String = ""
    var endDate:String = ""
    
    var NeedToReload:Bool = false
    var PageNumber:Int = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewDateInterval.layer.cornerRadius = viewDateInterval.frame.size.height / 2
        self.LoaderBackView.isHidden = true
        self.tblView.tableFooterView = UIView()
        print("arrVehicles in Response\(arrVehicles)")
        self.lblStartDate.text = self.DisplayPickupDate
//            self.startDate
        self.lblEndDate.text = self.DisplayDeliveryDate
//            self.endDate
//        self.webserviceFindVehicle()
        arrVehicles = [["Id":"111","vehiclemodel":"ford Figo","distance":"25","capicity":"5 seater","address":"30525 Linden Street PO Box 283 Lindstrom, MN 55045","carImage":"imgYellowCar"], ["Id":"112","vehiclemodel":"Mercedes Benz","distance":"15","capicity":"4 seater","address":"30525 Linden Street PO Box 283 London, MN 55045","carImage":"imgYellowCar"], ["Id":"113","vehiclemodel":"Verna Hundai","distance":"22","capicity":"5 seater","address":"US Main Street PO Box 283 London, MN 55045","carImage":"imgYellowCar"],["Id":"114","vehiclemodel":"Honda City","distance":"18","capicity":"5 seater","address":"111505 London Street PO Box 283 Lindstrom, MN 55055Z5","carImage":"imgYellowCar"],["Id":"228","vehiclemodel":"Scorpio","distance":"22","capicity":"5 seater","address":"30000 Linden Street PO Box 283 Lindstrom, MN 465001","carImage":"imgYellowCar"],["Id":"640","vehiclemodel":"ford Figo","distance":"25","capicity":"5 seater","address":"30525 Linden Street PO Box 283 Lindstrom, MN 55045","carImage":"imgYellowCar"]]
        //Adding more elements
        arrVehicles.append(contentsOf: arrVehicles)
        arrVehicles.append(contentsOf: arrVehicles)


    }
    
    func setupNavigationController()
    {
        setNavBarWithMenu(Title: "Home", IsNeedRightButton: false)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setupNavigationController()

//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "Select \(VehicalCat_IDName.1)", leftImage: kBack_Icon, rightImage: "", isTranslucent: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: nil)
        //#selector(self.openFilterView)
        
    }
    
//    @objc func openFilterView() {
//
//        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "VehicleFilterViewController") as! VehicleFilterViewController
//        viewController.Delegate = self
//        viewController.FilterCategoryName = VehicalCat_IDName.1
//        viewController.arrSelectedTypes = self.FilterByType.components(separatedBy: ",")
//        viewController.arrSelectedCategoryIds = self.FilterByModel.components(separatedBy: ",")
//        self.present(viewController, animated: true, completion: nil)
//
//    }
    func didVehicleBook(CustomCell: UITableViewCell) {
        
        let customIndexPath = self.tblView.indexPath(for: CustomCell)!
        let vehicleDetail = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailViewController") as! VehicleDetailViewController
        vehicleDetail.VehicleDetail = self.arrVehicles[customIndexPath.row] as [String : AnyObject]
        vehicleDetail.vehicleFrom_To = (startDate,endDate)
        vehicleDetail.startDisplayDate = self.DisplayPickupDate
        vehicleDetail.endDisplayDate = self.DisplayDeliveryDate
        vehicleDetail.selectedAddress = self.selectedAddress
        vehicleDetail.selectedAddLat = self.selectedAddLat
        vehicleDetail.selectedAddLong = self.selectedAddLong
        vehicleDetail.selectedTripType = self.selectedTripType
        vehicleDetail.VehicalCat_IDName = self.VehicalCat_IDName
        self.navigationController?.pushViewController(vehicleDetail, animated: true)
        
    }
    
}

// MARK: - Table view data source

extension SelectVehicleViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrVehicles.count > 0 ? arrVehicles.count : 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var CustomCell = UITableViewCell()
        if self.arrVehicles.count > 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVehicleViewCell") as! SelectVehicleViewCell
            
        ///Cell Border and Corener Radius
        cell.viewCell.layer.borderWidth = 1.2
        cell.viewCell.layer.borderColor = cellBorderColor.cgColor
//        cell.viewCell.layer.cornerRadius = 9.0
        cell.viewCell.layer.cornerRadius = 15
        cell.viewCell.layer.masksToBounds = true

            
        let VehicleDict = self.arrVehicles[indexPath.row]
        cell.DelegateForVehicalBook = self
//        cell.viewCell.backgroundColor = UIColor.white
//        cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
//        cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        cell.viewCell.layer.shadowOpacity = 0.4
//        cell.viewCell.layer.shadowRadius = 1
        

            cell.btnBook.layer.cornerRadius = 15
        cell.btnBook.tag = indexPath.row
        
        if let VehicleModel = VehicleDict["name"] as? String {
            cell.lblVehicleName.text = VehicleModel
        }
        
        if let capacity = VehicleDict["number_of_people"] as? String {
            cell.lblSeater.text = "\(capacity) seater"
        }
        
        if let Distance = VehicleDict["distance"] as? String {
            cell.lblDistance.text = "Within \(String(format: "%.2f", Double(Distance)!)) km"
        }
        
//        if let VehicleImageName = VehicleDict["image"] as? String {
//            let VehicleURL = URL(string: "\(WebserviceURLs.kImageVehicleBaseURL)\(VehicleImageName)")
//            cell.iconVehicle.sd_setShowActivityIndicatorView(true)
//            cell.iconVehicle.sd_setIndicatorStyle(.gray)
//            cell.iconVehicle.sd_setImage(with: VehicleURL, placeholderImage: UIImage(named: "imgYellowCar"))
//        }
        
        if let address = VehicleDict["address"] as? String {
            cell.lblAddress.text = address
        }
        CustomCell = cell
        if self.NeedToReload == true && indexPath.row == self.arrVehicles.count - 1  {
            self.reloadMoreHistory()
        }
        } else {
            let NoDataCell = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! UITableViewCell
            CustomCell = NoDataCell
        }
        
         CustomCell.selectionStyle = .none
        return CustomCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tblView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath)
        self.didVehicleBook(CustomCell: cell!)
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrVehicles.count > 0 {
            return 100
            //150
        } else {
            return 200
        }
    }
    
    func selectedFilter(byCategory: String, byType: String) {
        self.PageNumber = 1
        self.NeedToReload = false
        self.arrVehicles.removeAll()
        self.tblView.reloadData()
        
        self.FilterByModel = byCategory
        self.FilterByType = byType
//        self.webserviceFindVehicle()
    }
    
}


// MARK:- Custom Methods

extension SelectVehicleViewController {
    
    
    
    func reloadMoreHistory() {
        self.PageNumber += 1
        self.LoaderBackView.isHidden = false
        self.ActivityIndicator.startAnimating()
//        self.webserviceFindVehicle()
    }
    
//    func webserviceFindVehicle()
//    {
//        var dictParams = [String:Any]()
//
//        dictParams["pickup_location"] = self.selectedAddress
//        dictParams["start_lat"] = self.selectedAddLat
//        dictParams["start_lang"] = self.selectedAddLong
//        dictParams["pickup_time"] = self.startDate
//        //            self.selectedPickupTime
//        dictParams["drop_time"] = self.endDate
//        //                self.selectedDeliveryTime
//        dictParams["category"] = self.VehicalCat_IDName.0
//        dictParams["page"] = self.PageNumber
//
//        if FilterByType != "" {
//            dictParams["type"] = self.FilterByType
//        }
//
//        if FilterByModel != "" {
//            dictParams["model"] = self.FilterByModel
//        }
//
//        webserviceForFindVehicles(dictParams, showHUD: true) { (result, status) in
//            if status
//            {
//                print(result)
//                let arrVehicalList = result["data"] as! [[String : Any]]
//
//                if arrVehicalList.count == 10 {
//                    self.NeedToReload = true
//                } else {
//                    self.NeedToReload = false
//                }
//
//                if self.arrVehicles.count == 0 {
//                    self.arrVehicles = arrVehicalList
//                } else {
//                    self.arrVehicles.append(contentsOf: arrVehicalList)
//                }
//
//                if self.LoaderBackView.isHidden == false {
//                    self.ActivityIndicator.stopAnimating()
//                    self.LoaderBackView.isHidden = true
//                }
//
//                self.tblView.reloadData()
//
//                //                    let SuccessAlert = UIAlertController(title: "Password Updated Successfully.", message: "", preferredStyle: .alert)
//                //                    SuccessAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
//                //                        self.navigationController?.popViewController(animated: true)
//                //                    }))
//                //                    self.present(SuccessAlert, animated: true, completion: nil)
//
//            }else {
//                print(result)
//                if let ErrorMessages = (result as! NSDictionary).object(forKey: "error") as? [String] {
//                    let strMSG = ErrorMessages[0]
//                    Utilities.showAlert(appName, message: strMSG, vc: self)
//                } else if let ErrorMessage = (result as! NSDictionary).object(forKey: "error") as? String {
//                    let strMSG = ErrorMessage
//                    Utilities.showAlert(appName, message: strMSG, vc: self)
//                }
//            }
//        }
//
//    }
    
    
//    func getDummyVehicles() -> [[String: Any]] {
//
//        var arrayVehicles: [[String: Any]] = [
//                                                [
//                                                 "vehicleName" : "Ford Figo",
//                                                 "noOfSeats" : "5 Seater",
//                                                 "distance": "5.5 km",
//                                                 "Address": "Linden Street, PO Box No 12345"],
//                                                [
//                                                    "vehicleName" : "Ford Figo",
//                                                    "noOfSeats" : "5 Seater",
//                                                    "distance": "5.5 km",
//                                                    "Address": "Linden Street, PO Box No 12345"],
//                                                [
//                                                    "vehicleName" : "Ford Figo",
//                                                    "noOfSeats" : "5 Seater",
//                                                    "distance": "5.5 km",
//                                                    "Address": "Linden Street, PO Box No 12345"],
//                                                [
//                                                    "vehicleName" : "Ford Figo",
//                                                    "noOfSeats" : "5 Seater",
//                                                    "distance": "5.5 km",
//                                                    "Address": "Linden Street, PO Box No 12345"]
//                                            ]
//
//        return arrayVehicles
//    }
}
