//
//  VehicleDetailViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit

class VehicleDetailViewController: BaseViewController
{
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var imgVehicle: UIImageView!
    
    @IBOutlet var viewInfoVehicle: UIView!
    
    @IBOutlet var lblPriceperKM: UILabel!
    @IBOutlet var lblPriceDistance: UILabel!
    
    @IBOutlet var btnCheckAvailability: UIButton!
    
    @IBOutlet weak var btnApply: UIButton!
   
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var MainViewTop: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintCarsAvailabelView: NSLayoutConstraint!
    
//    var parallaxEffect: RKParallaxEffect!
    var VehicleDetail:[String:AnyObject] = [:]
    var vehicleFrom_To:(String,String) = ("","")
    var VehicalCat_IDName:(String,String) = ("","")
    var selectedAddress:String = ""
    var selectedAddLat = Double()
    var selectedAddLong = Double()
    var selectedTripType:String = ""
    var startDate:String = ""
    var endDate:String = ""
    
    
    var startDisplayDate:String = ""
    var endDisplayDate:String = ""
    var Fare:String = ""
    var SubTotal:String = ""
    var Total:String = ""
    var RentType:String = ""
    var Average:String = ""
    var Rate:String = ""
    var SpecialFare:String = ""
    var DeliveryFare:String = ""
    var Tax:String = ""
    
    var AppliedPromocode:String = ""
    var EnteredPromocode:String = ""
    var Discount:String = ""
    var PromoCodeId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startDate = vehicleFrom_To.0
        self.endDate = vehicleFrom_To.1
//        self.WebServiceForGetFare()
        let navigationbarHeight = self.navigationController?.navigationBar.frame.height
        let StatusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.MainViewTop.constant = 0 - (navigationbarHeight! + StatusBarHeight)
        
        // Do any additional setup after loading the view.
        
        ///Hiding the Availability View, initially
        self.bottomConstraintCarsAvailabelView.constant = -212.0
        

       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        setNavBarWithBack(Title: "Ford Figo", IsNeedRightButton: false,titleFontColor: UIColor.white)
        
        //Transperant
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "", leftImage: kBack_Icon, rightImage: "", isTranslucent: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        parallaxEffect = RKParallaxEffect(tableView: tblView)
        //        parallaxEffect.isParallaxEffectEnabled = true
        //        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = false
        //        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = false
    }
    
    
    //MARK : - TableView Method -
    
    
    
    
    //MARK: Button Clicks
    
    @IBAction func checkAvailabilityButtonClicked(_ sender: Any) {
        
//        if self.bottomConstraintCarsAvailabelView.constant == 0.0 {
//
//            ///Hide Cars Availabel View
//            self.bottomConstraintCarsAvailabelView.constant = -232.0
//        }
//        else{

            ///Show Cars Availabel View
            self.bottomConstraintCarsAvailabelView.constant =  0.0
//        }
    }

    @IBAction func closeCarsAvailabelButtonClicked(_ sender: Any) {
        
        ///Close cars available
        self.bottomConstraintCarsAvailabelView.constant = -232.0

        
    }
    @IBAction func btnBookConfirmClicked(_ sender: Any) {
//
//        let  PaymentviewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentPopUpViewController") as! SelectPaymentPopUpViewController
//        PaymentviewController.PaymentDelegate = self
//        self.present(PaymentviewController, animated: true, completion: nil)
        
    }
}

