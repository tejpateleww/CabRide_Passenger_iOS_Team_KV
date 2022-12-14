//
//  HomeWebserviceCalls.swift
//  Peppea
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

extension CarCollectionViewController: CarCollectionWebserviceProtocol {
  
    // ----------------------------------------------------
    // MARK:- --- Webservice For Booking ---
    // ----------------------------------------------------
    
    func validations() -> (Bool, String)
    {
        let pickup = (self.parent as! HomeViewController).pickupLocation
        let dropOff = (self.parent as! HomeViewController).destinationLocation
//        let bookingType = (self.parent as! HomeViewController).bookingType == "" ? "book_now" : (self.parent as! HomeViewController).bookingType

        
        if(pickup.latitude == 0 || pickup.longitude == 0 || pickup.latitude == 0.0 || pickup.longitude == 0.0)
        {
            return (false, "Please enter pickup location")
        }
        else if(dropOff.latitude == 0 || dropOff.longitude == 0 || dropOff.latitude == 0.0 || dropOff.longitude == 0.0)
        {
            return (false, "Please enter where to location")
        }
//        else if(bookingType.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
//        {
//            return (false, "Please select booking type")
//        }
        else if(vehicleId.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
        {
            return (false, "Please select vehicle")
        }
        else if (estimateFare.trimmingCharacters(in: .whitespacesAndNewlines) == "0.0" && self.btnBookNow.titleLabel?.text == "Book Now") {
            return (false, "Driver is not available")
        }
        else if(estimateFare.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
        {
            return (false, "Estimate fare is not available")
        }
        else if paymentType == "Select Payment Method" || paymentType == ""{
            return (false, "Please select payment method type")
        }
        return (true, "")
    }
    
    func webserviceForBooking(bookingType: String) {
        
        let homeVC = self.parent as? HomeViewController
        
        let address = (self.parent as! HomeViewController).pickupAndDropoffAddress
        let pickup = (self.parent as! HomeViewController).pickupLocation
        let dropOff = (self.parent as! HomeViewController).destinationLocation
//        let estimate = (self.parent as! HomeViewController).estimateFare
//        let bookingType = (self.parent as! HomeViewController).bookingType == "" ? "book_now" : (self.parent as! HomeViewController).bookingType
        
        let model = bookingRequest()
        model.booking_type = bookingType // "book_now" // "book_later"
        model.customer_id = SingletonClass.sharedInstance.loginData.id
        model.dropoff_lat = "\(dropOff.latitude == 0.0 ? 0 : dropOff.latitude)"
        model.dropoff_lng = "\(dropOff.longitude == 0.0 ? 0 : dropOff.longitude)"
        model.dropoff_location = address.dropOff
        model.no_of_passenger = "1"
        model.pickup_lat = "\(pickup.latitude == 0.0 ? 0 : pickup.latitude)"//   23.072622, 72.516409
        model.pickup_lng = "\(pickup.longitude == 0.0 ? 0 : pickup.longitude)"
        model.pickup_location = address.pickUp
        model.promocode = self.strPromoCode
        model.vehicle_type_id = vehicleId
        model.estimated_fare = (self.FlatRate != "") ? self.FlatRate : estimateFare
        model.payment_type = self.paymentType
        if self.paymentType == "card" {
            model.card_id = self.CardID
        } else if self.paymentType == "bulk_miles" {
            self.RentType = self.paymentType
        }
       
        if self.RentType == "fix_rate" {
            model.fix_rate_id = self.FlatRateId
        } else if self.RentType == "bulk_miles" {
            model.distance = self.Distance
        }
        
        model.rent_type =  (self.RentType == "") ? Rent_Type.standard_rate.rawValue : self.RentType
 
        if bookingType == "book_later" {
            model.pickup_date_time = selectedTimeStemp
        }
        
//        rent_type  :  fix_rate  OR standard_rate OR bulk_miles OR co_bulk_miles(IF rent_type == 'fix_rate' then 'fix_rate_id' is compulsory )
//        (if rent_type == bulk_miles then 'distance' is compulsory)
//        (if rent_type == co_bulk_miles then 'distance' is compulsory)
        
        UserWebserviceSubclass.bookingRequest(bookingRequestModel: model) { (response, status) in
            
            UtilityClass.hideHUD()
             homeVC?.btnBackButtonWhileBookLater()
//            self.btnBookNow.isUserInteractionEnabled = true
            
            print("Booking Response: \n", response)
            if status {
                
                let bookingType = response.dictionary?["data"]?.dictionary?["booking_type"]?.string ?? ""
                
                if bookingType == "book_now" {
//                    homeVC?.viewMainActivityIndicator.isHidden = false
//                    homeVC?.viewActivityAnimation.startAnimating()
                    homeVC?.dictForRejectCurrentReq.bookingId = response.dictionary?["data"]?.dictionary?["id"]?.string ?? ""
                    homeVC?.dictForRejectCurrentReq.customerId = SingletonClass.sharedInstance.loginData.id
                    
                    let activityVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestLodingViewController") as! RequestLodingViewController
                    activityVC.bookingId = response.dictionary?["data"]?.dictionary?["id"]?.string ?? ""
                    activityVC.customerId = SingletonClass.sharedInstance.loginData.id
                    activityVC.parentVc = homeVC
                    activityVC.modalPresentationStyle = .overCurrentContext
                    self.present(activityVC, animated: false, completion: nil)
                }
                homeVC?.mapView.clear()
                homeVC?.setupAfterComplete()
                let msg = response.dictionary?["message"]?.stringValue ?? response.dictionary?["message"]?.array?.first?.stringValue ?? ""
                
                AlertMessage.showMessageForSuccess(msg)
                
//                UtilityClass.showAlert(title: AppName.kAPPName, message: msg, alertTheme: .success)
//                UtilityClass.showDefaultAlertView(withTitle: AppName.kAPPName, message: msg, buttons: ["OK"], completion: { (index) in
////                    homeVC?.setupAfterComplete()
//                })

            } else {
                let msg = (response.dictionary?["message"]?.stringValue == "") ? response.dictionary?["message"]?.array?.first?.stringValue ?? "" : response.dictionary?["message"]?.stringValue
                
                UtilityClass.hideHUD()
                let storyboard = UIStoryboard(name: "Popup", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "VerifyCustomerPopupViewController") as? VerifyCustomerPopupViewController {
                    if(response["past_due"].int != nil)
                    {
                        vc.strMessage = "Dear Customer\n\(msg ?? "")"
//                        vc.strTitle = "Dear Customer"
                        vc.strBtnTitle = "Pay Now"
                        vc.shouldRedirect = true
                        vc.redirectToPaymentList = {
                            // TODO:- Commented by Bhumi Jani for stop redirecting to Previous Due Screen
                            vc.dismiss(animated: true, completion: nil)
//                            let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "PreviousDueViewController") as! PreviousDueViewController
//                            self.navigationController?.pushViewController(NextPage, animated: true)
                            
                            if let payment = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
                                payment.Delegate = self
                                payment.isFromSideMenu = true
                                payment.OpenedForPayment = true
                                payment.isForPaymentDue = true
                                let NavController = UINavigationController(rootViewController: payment)
                                self.navigationController?.present(NavController, animated: true, completion: nil)
                            }
                        }
                    }
                    else
                    {
                        vc.strMessage = "Dear Customer\n\(msg ?? "")"
//                        vc.strTitle = "Dear Customer"
                        vc.strBtnTitle = "OK"
                        vc.shouldRedirect = true
                        vc.redirectToPaymentList = {
                            vc.dismiss(animated: true, completion: nil)
                        }
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func webserviceForCheckPromocodeService(promoCode: String) {
        
        let model = CheckPromocode()
        model.promocode = promoCode
        
        UserWebserviceSubclass.checkPromocodeService(Promocode: model) { (response, status) in
            print(response)
            if status {
                self.strPromoCode = promoCode
                self.promoCodeId = response.dictionary?["promocode_id"]?.string ?? ""
                
                let attributedString = NSAttributedString(string: promoCode, attributes: [
                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), //your font here
                    NSAttributedString.Key.foregroundColor : ThemeOrange
                ])
                
                let SuccessAlert = UIAlertController(title: "", message: "Thanks Chick, All Done!", preferredStyle: .alert)
                SuccessAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
                    
                }))
                SuccessAlert.setValue(attributedString, forKey: "attributedTitle")
                self.present(SuccessAlert, animated: true, completion: nil)
                
        
//                UtilityClass.showDefaultAlertView(withTitle: "Congratulations!!", message: "Thanks Chick, All Done!", buttons: ["Ok"], completion: { (ind) in
//                })
                self.stackViewPromoCode.isHidden = false
                
                let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.black]
                let attrs2 = [NSAttributedString.Key.foregroundColor : UIColor.init(hex: "#2fa918")]
                let attributedString1 = NSMutableAttributedString(string:"Promo Code Applied ", attributes:attrs1)
                let attributedString2 = NSMutableAttributedString(string:"\(promoCode)", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.lblPromo.attributedText = attributedString1
            } else {
                self.strPromoCode = ""
                self.promoCodeId = ""
                AlertMessage.showMessageForError(response.dictionary?["message"]?.string ?? "")
            }
        }
    }
    
    func webserviceForBulkPaymentPreviousDue() {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        UserWebserviceSubclass.BulkPreviousDuePaymentData(SendChat: previousDuePaymentModel) { (response, status) in
            UtilityClass.hideHUD()
            if status {
                
                UtilityClass.showDefaultAlertView(withTitle: "", message: response.dictionary?["message"]?.string ?? "", buttons: ["Ok"], completion: { (ind) in
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                UtilityClass.showDefaultAlertView(withTitle: "", message: response.dictionary?["message"]?.string ?? "", buttons: ["Ok"], completion: { (ind) in
                    
                })
            }
        }
    }
}


