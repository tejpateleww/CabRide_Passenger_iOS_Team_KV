//
//  VehicleDetailViewController.swift
//  RentInFlash-Customer
//
//  Created by EWW iMac2 on 14/11/18.
//  Copyright © 2018 EWW iMac2. All rights reserved.
//

import UIKit

class VehicleDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var imgVehicle: UIImageView!
    
    @IBOutlet var viewInfoVehicle: UIView!
    
    @IBOutlet var lblPriceperKM: UILabel!
    @IBOutlet var lblPriceDistance: UILabel!
    
    @IBOutlet var btnBookConfirm: UIButton!
    
    @IBOutlet weak var btnApply: UIButton!
   
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var MainViewTop: NSLayoutConstraint!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        parallaxEffect = RKParallaxEffect(tableView: tblView)
        //        parallaxEffect.isParallaxEffectEnabled = true
        //        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = false
        //        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = false
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        Utilities.setNavigationBarInViewController(controller: self, naviColor: ThemeNaviLightBlueColor, naviTitle: "", leftImage: kBack_Icon, rightImage: "", isTranslucent: true)
    }
    
    //MARK : - TableView Method -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var customCell = UITableViewCell()
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleFirstTimeDurationCell") as! VehicleFirstTimeDurationCell
            
            
            //            cell.viewCell.backgroundColor = UIColor.white
            cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.viewCell.layer.shadowOpacity = 0.4
            cell.viewCell.layer.shadowRadius = 1
            
            cell.viewCell.layer.cornerRadius = cell.viewCell.frame.height / 2
            
            cell.lblPickupTime.text = self.startDisplayDate
            cell.lblDropoffTime.text = self.endDisplayDate
            
            cell.layer.zPosition = (indexPath.row == 0) ? 1 : 0
            cell.selectionStyle = .none
            
            customCell = cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailMapViewCell") as! VehicleDetailMapViewCell
            //        cell.viewCell.layer.cornerRadius = 10
            //        cell.viewCell.layer.borderWidth = 1
            //        cell.viewCell.layer.borderColor = UIColor.lightGray.cgColor
            
            
            cell.viewCell.backgroundColor = UIColor.white
            cell.viewCell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.viewCell.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.viewCell.layer.shadowOpacity = 0.4
            cell.viewCell.layer.shadowRadius = 1
            cell.viewCell.layer.cornerRadius = 10
            
            cell.MapViewLatitude = 23.0
                //self.selectedAddLat
            cell.MapViewlongitude = 73.0
                //self.selectedAddLong
            cell.MapViewAddress = "30525 Linden Street PO Box 283 Lindstrom, MN 55045"
                //self.selectedAddress
            
            cell.setPinonMap()
            
            
            //        cell.viewCell.layer.masksToBounds = true
            //        cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
            //        cellMenu.selectionStyle = .none
            //
            //        cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
            
            customCell = cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclePaymentBreakdownCell") as! VehiclePaymentBreakdownCell
//            cell.Delegate = self
//            cell.lblFarePriceKM.text = "\(currency) \( (self.Fare != "") ? String(format: "%.2f", (self.Fare as NSString).doubleValue) : "")"
//            cell.lblRefundableDeposit.text = "\(currency) \( (self.Fare != "") ? String(format: "%.2f", (self.Fare as NSString).doubleValue) : "")"
//            cell.lblSpecialFare.text = "\(currency) \( (self.SpecialFare != "") ? String(format: "%.2f", (self.SpecialFare as NSString).doubleValue) : "")"
//            cell.lblDeliveryFare.text = "\(currency) \( (self.DeliveryFare != "") ? String(format: "%.2f", (self.DeliveryFare as NSString).doubleValue) : "")"
//            cell.lblTaxAmount.text = "\(currency) \( (self.Tax != "") ? String(format: "%.2f", (self.Tax as NSString).doubleValue) : "")"
            cell.PromoView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.PromoView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.PromoView.layer.shadowOpacity = 0.4
            cell.PromoView.layer.shadowRadius = 1
            cell.PromoView.layer.cornerRadius = 10
            
            cell.btnApply.layer.cornerRadius = 5.0
            cell.btnApply.layer.masksToBounds = true
            
            
            if self.selectedTripType == "delivery" {
                cell.ViewDeliveryFare.isHidden = false
            } else {
                cell.ViewDeliveryFare.isHidden = true
            }
            
            if self.AppliedPromocode  != "" {
                cell.txtHavePromoCode.isEnabled = false
                cell.btnRemovePromocode.isHidden = false
                cell.imgVerified.isHidden = false
            } else {
                cell.txtHavePromoCode.isEnabled = true
                cell.btnRemovePromocode.isHidden = true
                cell.imgVerified.isHidden = true
            }
            
            customCell = cell
        }
        else if indexPath.section == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailTotalAmountCell") as! VehicleDetailTotalAmountCell
            
            if self.Discount != "" {
//                cell.lblDiscountAmount.text = "\(currency) \( (self.Discount != "") ? String(format: "%.2f", (self.Discount as NSString).doubleValue) : "")"
                cell.promocodeView.isHidden = false
                
                let FinalAmount = Double(Double(self.Total)! - Double(self.Discount)!)
//                cell.lblTotalAmount.text = "\(currency)\(String(format: "%.2f", FinalAmount))"
//                if self.Total != "" {
//
//                    cell.lblTotalAmount.text = "\(currency)\((self.Total.contains(".") ? self.Total : (String(format: "%.2f",Double(self.Total)!))))"
//                }
            } else {
                cell.lblDiscountAmount.text = ""
                cell.promocodeView.isHidden = true
                if self.Total != "" {
//                    cell.lblTotalAmount.text = "\(currency)\((self.Total.contains(".") ? self.Total : (String(format: "%.2f",Double(self.Total)!))))"
                }
            }
            
            customCell = cell
        }
        else if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailExtraChargesCell") as! VehicleDetailExtraChargesCell
            cell.viewNotes.layer.cornerRadius = 10
            cell.viewNotes.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewNotes.layer.borderWidth = 1
            customCell = cell
        }
        customCell.selectionStyle = .none
        return customCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        tblView.deselectRow(at: indexPath, animated: true)
        //        let  viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchForVehicleViewController") as! SearchForVehicleViewController
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.section == 0 {
            return 0.0
        }
        else if indexPath.section == 1
        {
            return 170
        }
        else if indexPath.section == 2
        {
            return UITableView.automaticDimension
        }
        else if indexPath.section == 3
        {
            return 70
        }
        else if indexPath.section == 4
        {
            return 120
        }
        else
        {
            return 60
        }
    }
    
    
    //IBAction Methods
    
    @IBAction func btnBookConfirmClicked(_ sender: Any) {
//
//        let  PaymentviewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentPopUpViewController") as! SelectPaymentPopUpViewController
//        PaymentviewController.PaymentDelegate = self
//        self.present(PaymentviewController, animated: true, completion: nil)
        
    }
}

//MARK:- Custom Methods

/*
extension VehicleDetailViewController:SelectCardDelegate {
    
    func DidSelectCard(card_Detail: [String : Any]) {
        
        let  PaymentviewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentPopUpViewController") as! SelectPaymentPopUpViewController
        PaymentviewController.PaymentDelegate = self
        PaymentviewController.selectedPaymentMethod = "card"
        PaymentviewController.PaymentCardDetail = card_Detail
        self.present(PaymentviewController, animated: true, completion: nil)
        
    }
    
    func setVehicleDetail() {
        
        if let ImageUrl = VehicleDetail["image"] as? String {
            let stringImagURL = "\(WebserviceURLs.kImageVehicleBaseURL)\(ImageUrl)"
            //            cell.imgProduct?.image = UIImage(named: self.arrVehicalImage[indexPath.row])
            
            self.imgVehicle.sd_setShowActivityIndicatorView(true)
            self.imgVehicle.sd_setIndicatorStyle(.gray)
            self.imgVehicle.sd_setImage(with: URL.init(string: stringImagURL), placeholderImage: UIImage.init(named: ""), completed: nil)
        } else {
            if let ImageURLs = VehicleDetail["images"] as? [[String:AnyObject]] {
                if ImageURLs.count > 0 {
                let ImageDetail = ImageURLs[0]
                if let ImageURL = ImageDetail["image"] as? [String:AnyObject] {
                    let stringImagURL = "\(WebserviceURLs.kImageVehicleBaseURL)\(ImageURL)"
                    self.imgVehicle.sd_setShowActivityIndicatorView(true)
                    self.imgVehicle.sd_setIndicatorStyle(.gray)
                    self.imgVehicle.sd_setImage(with: URL.init(string: stringImagURL), placeholderImage: UIImage.init(named: ""), completed: nil)
                }
                }
            }
        }
        

        self.lblPriceDistance.text = "\(currency)\((self.SubTotal.contains(".") ? self.SubTotal : (String(format: "%.2f",Double(self.SubTotal)!)))) - \((self.Average.contains(".") ? self.Average : (String(format: "%.2f",Double(self.Average)!))))"
        self.lblPriceperKM.text = "\(currency)\(String(format: "%.2f",Double(self.Rate)!)) - per \(self.RentType)"
        self.tblView.reloadData()
        
    }
    
    func WebServiceForGetFare() {
        
        var dictParams = [String:Any]()
        
        dictParams["pickup_location"] = self.selectedAddress
        dictParams["pickup_lat"] = self.selectedAddLat
        dictParams["pickup_lang"] = self.selectedAddLong
        dictParams["pickup_time"] = self.startDate
        dictParams["drop_time"] = self.endDate
        dictParams["type"] = self.selectedTripType
        
        if let VehicleId = self.VehicleDetail["id"] as? String {
            dictParams["vehicle_id"] = VehicleId
        } else if let VehicleId = self.VehicleDetail["id"] as? Int {
            dictParams["vehicle_id"] = VehicleId
        }
        
        webserviceForGetFares(dictParams, showHUD: true) { (result, status) in
            if status {
                print(result)
                if let ResponseData = result["data"] as? [String:AnyObject] {
                    if let Avg = ResponseData["avg"] as? Int {
                        self.Average = "\(Avg)"
                    } else if let Avg = ResponseData["avg"] as? Double {
                        self.Average = "\(Avg)"
                    }
                    
                    if let BaseRate = ResponseData["base_rate"] as? String {
                        self.Fare = BaseRate
                    }
                    
                    if let Total = ResponseData["total"] as? Int {
                        self.Total = "\(Total)"
                    } else if let Total = ResponseData["total"] as? Double {
                        self.Total = "\(Total)"
                    }
                    
                    if let DeliveryFare = ResponseData["delivery_fare"] as? Int {
                        self.DeliveryFare = "\(DeliveryFare)"
                    } else if let DeliveryFare = ResponseData["delivery_fare"] as? Double {
                        self.DeliveryFare = "\(DeliveryFare)"
                    } else if let DeliveryFare = ResponseData["delivery_fare"] as? String {
                        self.DeliveryFare = "\(DeliveryFare)"
                    }
                    
                    if let BookingTax = ResponseData["tax"] as? Int {
                        self.Tax = "\(BookingTax)"
                    } else if let BookingTax = ResponseData["tax"] as? Double {
                        self.Tax = "\(BookingTax)"
                    } else if let BookingTax = ResponseData["tax"] as? String {
                        self.Tax = "\(BookingTax)"
                    }
                    
                    if let SpecialFare = ResponseData["special_fare"] as? Int {
                        self.SpecialFare  = "\(SpecialFare)"
                    } else if let SpecialFare = ResponseData["special_fare"] as? Double {
                        self.SpecialFare = "\(SpecialFare)"
                    } else if let SpecialFare = ResponseData["special_fare"] as? String {
                        self.SpecialFare = "\(SpecialFare)"
                    }
                    
                    if let SubTtl = ResponseData["sub_total"] as? Int {
                        self.SubTotal = "\(SubTtl)"
                    } else if let SubTtl = ResponseData["sub_total"] as? Double {
                        self.SubTotal = "\(SubTtl)"
                    }
                    
                    if let Type = ResponseData["type"] as? String {
                        self.RentType = Type
                    }
                    if let BasicRate = ResponseData["rate"] as? String {
                        self.Rate = BasicRate
                    }
                    
                    self.setVehicleDetail()
                }
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
    
    func WebServiceForApplyPromocode(Promo:String, Amount:String) {
        
        var dictParams = [String:Any]()
        
        if let UserID = SingletonClass.sharedInstance.dictCustomerProfile["id"] as? NSNumber {
            dictParams["user_id"] = UserID as AnyObject
        }
       
        dictParams["code"] = Promo
        dictParams["amount"] = Amount
        
        webserviceForApplyPromoCode(dictParams, showHUD: true) { (result, status) in
            if status {
                print(result)
                 if let ResponseData = result["data"] as? [String:AnyObject] {
                    self.AppliedPromocode = self.EnteredPromocode
                    if let Discount = ResponseData["discount"] as? Int {
                        self.Discount = "\(Discount)"
                    } else if let Discount = ResponseData["discount"] as? String {
                        self.Discount = "\(Discount)"
                    }
                    
                    if let PromoID = ResponseData["promo_id"] as? Int {
                        self.PromoCodeId = "\(PromoID)"
                    } else if let PromoID = ResponseData["promo_id"] as? String {
                        self.PromoCodeId = "\(PromoID)"
                    }
                    
                    self.tblView.reloadData()
                }
                
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
    
    func WebServiceForRequest(Type:String, PaymentType:String, chargeId:String, transactionId:String, customerId:String) {
        print(#function)
        var dictParams = [String:Any]()
        
        if let UserID = SingletonClass.sharedInstance.dictCustomerProfile["id"] as? NSNumber {
            dictParams["user_id"] = UserID as AnyObject
        }
        
        dictParams["pickup_location"] = self.selectedAddress
        dictParams["pickup_lat"] = self.selectedAddLat
        dictParams["pickup_lang"] = self.selectedAddLong
        dictParams["pickup_time"] = self.startDate
        dictParams["drop_time"] = self.endDate
        if let VehicleId = self.VehicleDetail["id"] as? String {
            dictParams["vehicle_id"] = VehicleId
        } else if let VehicleId = self.VehicleDetail["id"] as? Int {
            dictParams["vehicle_id"] = VehicleId
        }
        
        dictParams["type"] = self.selectedTripType
        dictParams["payment_type"] = PaymentType
        
        if PaymentType == "card" {
            dictParams["charge_id"] = chargeId
            dictParams["transaction_id"] = transactionId
            dictParams["customer_id"] = customerId
        }
        
        if self.PromoCodeId != "" {
            dictParams["promo_id"] = self.PromoCodeId
        }
        
        webserviceForBookingRequest(dictParams, showHUD: true) { (result, status) in
            if status {
                print(result)
                if let ResponseMsg = result["data"] as? String {
                    let alert = UIAlertController(title: appName,
                                                  message: ResponseMsg,
                                                  preferredStyle: UIAlertController.Style.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
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
    
}
 */

/*

// MARK:- did Open AddCardList method
extension VehicleDetailViewController : PaymentViewActionsDelegate, TryPromoCodeDelegate {
    
    func didTestPromoCode(Promocode: String) {
        if Promocode != "" {
            self.WebServiceForApplyPromocode(Promo: Promocode, Amount: String(format: "%.2f",Double(self.Total)!))
        } else {
           Utilities.showAlert(appName, message: "Please enter promo code.", vc: self)
        }
    }
    
    func didChangePromoCode(Promocode: String) {
        self.EnteredPromocode = Promocode
    }
    
    func didRemovePromoCode() {
     
        self.AppliedPromocode = ""
        self.Discount = ""
        self.PromoCodeId = ""
        
        self.tblView.reloadData()
    }
    
    func didOpenAddCardList() {
        
        let AddCardList = self.storyboard?.instantiateViewController(withIdentifier: "AddCard_CardListViewController") as! AddCard_CardListViewController
        AddCardList.Delegate = self
        self.navigationController?.pushViewController(AddCardList, animated: true)
        
    }
    
    func didComplementPayment(PaymentType: String) {
//        if PaymentType == "cash" {
        
            self.WebServiceForRequest(Type: "pickup", PaymentType: PaymentType, chargeId: "", transactionId: "", customerId: "")
            
//        } else if PaymentType == "card" {
//
//            self.WebServiceForRequest(Type: "pickup", PaymentType: PaymentType, chargeId: "", transactionId: "", customerId: "")
//
//        }
    }
    
    func didCompletePaymentByCard(CardDetail: [String : Any]) {
        print(#function)
        let CardID = CardDetail["id"] as! String
        let customerId = SingletonClass.sharedInstance.dictCustomerProfile["stripe_id"] as! String
        
        var dictCharge = [String:Any]()
        let amount = self.Total.integerValue! * 100
        dictCharge["amount"] = amount
        dictCharge["currency"] = "usd"
        dictCharge["source"] = CardID
        dictCharge["customer"] = customerId
        
        StripeCardClass.StripeSharedInstance.ChargeCustomer(RequiredParams: dictCharge) { (Result, Status) in
            if Status {
                if let ResponseData = Result as? [String:Any] {
                    
                    if let ChargeId = ResponseData["id"] as? String, let TransecId = ResponseData["balance_transaction"] as? String {
                        
                        let customer_Id = SingletonClass.sharedInstance.dictCustomerProfile["stripe_id"] as! String
                        
                        self.WebServiceForRequest(Type: "pickup", PaymentType: "card", chargeId: ChargeId, transactionId: TransecId, customerId: customer_Id)
                    
                    }
                }
            } else {
                
            }
        }
        
    }
}
*/
