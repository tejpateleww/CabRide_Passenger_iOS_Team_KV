//
//  SelectVehicleViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 13/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit
import GooglePlaces

//CategoryFileterDelegate
class SelectVehicleViewController: BaseViewController,BookVehicleDelegate
{
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var viewDateInterval: UIView!
    
    @IBOutlet weak var lblPickUpDate: UILabel!
    @IBOutlet weak var lblDropOffDate: UILabel!
    
    var placeSelected: GMSPlace?
    var selectedPickUpDate: String = ""
    var selectedDropOffDate: String = ""
    
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

//        viewDateInterval.layer.cornerRadius = viewDateInterval.frame.size.height / 2
//        self.lblStartDate.text = self.DisplayPickupDate
//        //            self.startDate
//        self.lblEndDate.text = self.DisplayDeliveryDate

        
        self.lblPickUpDate.text = self.selectedPickUpDate.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
        self.lblDropOffDate.text = self.selectedDropOffDate.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
        
        self.LoaderBackView.isHidden = true
        self.tblView.tableFooterView = UIView()
        print("arrVehicles in Response\(arrVehicles)")
//            self.endDate
//        self.webserviceFindVehicle()

        arrVehicles = self.loadData()
        //Adding more elements
        arrVehicles.append(contentsOf: arrVehicles)
        arrVehicles.append(contentsOf: arrVehicles)


    }
    
//    func setupNavigationController()
//    {
//
//        self.title = "Select Car"
//        self.navigationController?.navigationBar.barTintColor = .white
////        self.navigationController?.navigationBar.isTranslucent = true
//
//    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        setNavBarWithBack(Title: "Select Car", IsNeedRightButton: false, barColor: .white,titleFontColor: .black,backBarButtonColor: .black)

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
   
    func selectedFilter(byCategory: String, byType: String) {
        self.PageNumber = 1
        self.NeedToReload = false
        self.arrVehicles.removeAll()
        self.tblView.reloadData()
        
        self.FilterByModel = byCategory
        self.FilterByType = byType
        //        self.webserviceFindVehicle()
    }
    
    
    func loadData() -> [Dictionary<String,Any>] {
        
        
        let arrVehicles = [["Id":"111","vehiclemodel":"ford Figo","distance":"25","capicity":"5 seater","address":"30525 Linden Street PO Box 283 Lindstrom, MN 55045","carImage":"imgYellowCar"], ["Id":"112","vehiclemodel":"Mercedes Benz","distance":"15","capicity":"4 seater","address":"30525 Linden Street PO Box 283 London, MN 55045","carImage":"imgYellowCar"], ["Id":"113","vehiclemodel":"Verna Hundai","distance":"22","capicity":"5 seater","address":"US Main Street PO Box 283 London, MN 55045","carImage":"imgYellowCar"],["Id":"114","vehiclemodel":"Honda City","distance":"18","capicity":"5 seater","address":"111505 London Street PO Box 283 Lindstrom, MN 55055Z5","carImage":"imgYellowCar"],["Id":"228","vehiclemodel":"Scorpio","distance":"22","capicity":"5 seater","address":"30000 Linden Street PO Box 283 Lindstrom, MN 465001","carImage":"imgYellowCar"],["Id":"640","vehiclemodel":"ford Figo","distance":"25","capicity":"5 seater","address":"30525 Linden Street PO Box 283 Lindstrom, MN 55045","carImage":"imgYellowCar"]]
        
        return arrVehicles
        
    }
    
}

