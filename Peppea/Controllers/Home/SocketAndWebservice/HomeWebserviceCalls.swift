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
        let bookingType = (self.parent as! HomeViewController).bookingType == "" ? "book_now" : (self.parent as! HomeViewController).bookingType
        
        
        if(pickup.latitude == 0 || pickup.longitude == 0)
        {
            return (false, "Please enter pickup location")
        }
        else if(dropOff.latitude == 0 || dropOff.longitude == 0)
        {
            return (false, "Please enter dropoff location")
        }
        else if(bookingType.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
        {
            return (false, "Please select booking type")
        }
        else if(vehicleId.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 && self.btnBookNow.titleLabel?.text == "Book Now")
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
        return (true, "")
    }
    
    func webserviceForBooking(bookingType: String) {
        
        let address = (self.parent as! HomeViewController).pickupAndDropoffAddress
        let pickup = (self.parent as! HomeViewController).pickupLocation
        let dropOff = (self.parent as! HomeViewController).destinationLocation
//        let estimate = (self.parent as! HomeViewController).estimateFare
//        let bookingType = (self.parent as! HomeViewController).bookingType == "" ? "book_now" : (self.parent as! HomeViewController).bookingType
        
        let model = bookingRequest()
        model.booking_type = bookingType // "book_now" // "book_later"
        model.customer_id = SingletonClass.sharedInstance.loginData.id
        model.dropoff_lat = "\(dropOff.latitude == 0.0 ? 23.073783 : dropOff.latitude)"
        model.dropoff_lng = "\(dropOff.longitude == 0.0 ? 72.52645 : dropOff.longitude)"
        model.dropoff_location = address.dropOff
        model.no_of_passenger = "1"
        model.pickup_lat = "\(pickup.latitude == 0.0 ? 23.072622 : pickup.latitude)"//   23.072622, 72.516409
        model.pickup_lng = "\(pickup.longitude == 0.0 ? 72.516409 : pickup.longitude)"
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
        
        UserWebserviceSubclass.bookingRequest(bookingRequestModel: model) { (response, status) in
            
            print("Booking Response: \n", response)
            if status {
//                 let homeVC = self.parent as? HomeViewController
//                 homeVC?.btnBackButtonWhileBookLater()
                
                let msg = response.dictionary?["message"]?.stringValue ?? response.dictionary?["message"]?.array?.first?.stringValue ?? ""
                
                UtilityClass.showAlert(title: AppName.kAPPName.rawValue, message: msg, alertTheme: .success)
                
            } else {
                let msg = response.dictionary?["message"]?.stringValue ?? response.dictionary?["message"]?.array?.first?.stringValue ?? ""
                
                UtilityClass.showAlert(title: AppName.kAPPName.rawValue, message: msg, alertTheme: .error)
                
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
                AlertMessage.showMessageForSuccess(response.dictionary?["message"]?.string ?? "")
            } else {
                self.strPromoCode = ""
                AlertMessage.showMessageForError(response.dictionary?["message"]?.string ?? "")
            }
        }
        
    }
    
}
