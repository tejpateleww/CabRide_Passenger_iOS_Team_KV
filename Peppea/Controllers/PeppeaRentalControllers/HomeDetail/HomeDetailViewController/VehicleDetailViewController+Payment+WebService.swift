//
//  VehicleDetailViewController+WebService.swift
//  Peppea
//
//  Created by EWW078 on 28/09/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation




extension VehicleDetailViewController: didSelectPaymentDelegate {
    
    func didSelectPaymentType(PaymentType: String, PaymentTypeID: String, PaymentNumber: String, PaymentHolderName: String) {
        
    }
    
    
    
    
}
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
