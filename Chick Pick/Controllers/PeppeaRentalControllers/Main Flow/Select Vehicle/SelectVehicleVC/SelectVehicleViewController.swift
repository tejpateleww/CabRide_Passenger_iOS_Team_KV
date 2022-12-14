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
    var selectedPickUpDateString: String = ""
    var selectedDropOffDateString: String = ""
    
    var VehicalCat_IDName:(String,String) = ("","")
    
    var FilterByModel:String = ""
    var FilterByType:String = ""
    
    var DisplayPickupDate:String = ""
    var DisplayDeliveryDate:String = ""
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var LoaderBackView: UIView!
    
    var arrVehicles:[[String:Any]] = []
    var startDate:String = ""
    var endDate:String = ""
    
    var NeedToReload:Bool = false
    var PageNumber:Int = 1
    @IBOutlet weak var filterOkButton: UIButton!
    
    @IBOutlet weak var shaddowView: UIView!
    @IBOutlet weak var filterOuterViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterOuterView: UIView!
    
//
//    lazy var filterButton: UIButton = {
//
//        let button = UIButton(type: .system)
//
//        button.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
//
//        button.setImage(UIImage(named: "filter"), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
//
//        button.tintColor = UIColor.black
//
//        button.addTarget(self, action: #selector(self.filterButtonClicked), for: .touchUpInside)
//
//        return button
//    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

//        viewDateInterval.layer.cornerRadius = viewDateInterval.frame.size.height / 2
//        self.lblStartDate.text = self.DisplayPickupDate
//        //            self.startDate
//        self.lblEndDate.text = self.DisplayDeliveryDate

        self.setUpFilterViewFirstTime()
        
        self.lblPickUpDate.text = self.selectedPickUpDateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
        self.lblDropOffDate.text = self.selectedDropOffDateString.convertDateString(inputFormat: .dateWithOutSeconds, outputFormat: .fullDate)
        
//        self.LoaderBackView.isHidden = true
        self.tblView.tableFooterView = UIView()
        print("arrVehicles in Response\(arrVehicles)")
//            self.endDate
//        self.webserviceFindVehicle()

        arrVehicles = self.loadData()
        //Adding more elements
        arrVehicles.append(contentsOf: arrVehicles)
        arrVehicles.append(contentsOf: arrVehicles)


    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        setNavBarWithBack(Title: "Select Car", IsNeedRightButton: false)
        self.navigationItem.title = "Select Car"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(self.filterButtonClicked))
            //UIBarButtonItem(customView: self.filterButton)
            //
            //
            //
        
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
    
    
    //MARK: Filter Button Click
    
    func setUpFilterViewFirstTime() {
        
        let filterByVC : FilterByViewController = self.storyboard!.instantiateViewController(withIdentifier: "FilterByViewController") as! FilterByViewController
        
        ///1.
        self.filterOuterView.addSubview(filterByVC.view)
        filterByVC.view.frame = CGRect(x: 0, y: 73.0, width: UIScreen.main.bounds.width, height: 267.0)
        
        ///2.
        self.addChild(filterByVC)
        
        ///3.
        filterByVC.didMove(toParent: self)
        
        filterByVC.view.layoutIfNeeded()
        
        ///Filter Ok Button
        self.filterOkButton.layer.cornerRadius = self.filterOkButton.frame.height / 2.0
        self.filterOkButton.layer.masksToBounds = true
        
        ///Filter Bottom Constarint
        //Here height is 417
        self.filterOuterViewBottomConstraint.constant = -self.filterOuterView.frame.height
        
        ///
        self.shaddowView.isHidden = true
        
    }
    
    @objc func filterButtonClicked() {
        
        if self.filterOuterViewBottomConstraint.constant == 0.0 {

            ///Hide Filter View
            self.filterOuterViewBottomConstraint.constant = -self.filterOuterView.frame.height
            self.shaddowView.isHidden = true
        }else{

            //Show Filter View
            self.filterOuterViewBottomConstraint.constant = 0.0
            self.shaddowView.isHidden = false
        }
        
        
    }
    @IBAction func filterOkButtonClicked(_ sender: Any) {
        
         self.filterOuterViewBottomConstraint.constant = -self.filterOuterView.frame.height
        self.shaddowView.isHidden = true

    }
    
    
   
}



