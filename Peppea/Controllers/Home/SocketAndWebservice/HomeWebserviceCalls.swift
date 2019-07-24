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
    
    func webserviceForBooking() {
        
        let address = (self.parent as! HomeViewController).pickupAndDropoffAddress
        let pickup = (self.parent as! HomeViewController).pickupLocation
        let dropOff = (self.parent as! HomeViewController).destinationLocation
//        let estimate = (self.parent as! HomeViewController).estimateFare
        let bookingType = (self.parent as! HomeViewController).bookingType == "" ? "book_now" : (self.parent as! HomeViewController).bookingType
        
        let model = bookingRequest()
        model.booking_type = bookingType // "book_now" // "book_later"
        model.customer_id = SingletonClass.sharedInstance.loginData.id
        model.dropoff_lat = "\(dropOff.latitude)"
        model.dropoff_lng = "\(dropOff.longitude)"
        model.dropoff_location = address.dropOff
        model.no_of_passenger = "1"
        model.payment_type = "cash"
        model.pickup_lat = "\(pickup.latitude == 0.0 ? 23.072622 : pickup.latitude)"//   23.072622, 72.516409
        model.pickup_lng = "\(pickup.longitude == 0.0 ? 72.516409 : pickup.longitude)"
        model.pickup_location = address.pickUp
        model.promocode = ""
        model.vehicle_type_id = vehicleId
        model.estimated_fare = estimateFare
        
        UserWebserviceSubclass.bookingRequest(bookingRequestModel: model) { (response, status) in
            
            print("Booking Response: \n", response)
            if status {
                
                let msg = response.dictionary?["message"]?.stringValue ?? response.dictionary?["message"]?.array?.first?.stringValue ?? ""
                
                UtilityClass.showAlert(title: AppName.kAPPName, message: msg, alertTheme: .success)
                
            } else {
                let msg = response.dictionary?["message"]?.stringValue ?? response.dictionary?["message"]?.array?.first?.stringValue ?? ""
                
                UtilityClass.showAlert(title: AppName.kAPPName, message: msg, alertTheme: .error)
                
            }
        }
    }
    

    
}
