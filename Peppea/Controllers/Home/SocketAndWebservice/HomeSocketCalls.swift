//
//  HomeSocketCalls.swift
//  Peppea
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import SwiftyJSON

extension HomeViewController: SocketConnected {

    
    // ----------------------------------------------------
    // MARK:- --- All Socket Methods ---
    // ----------------------------------------------------
    func allSocketOnMethods() {
        
        onSocket_GetEstimateFare()                  // Socket On 1
        onSocket_AfterDriverAcceptRequest()         // Socket On 2
        onSocket_StartTrip()                        // Socket On 3
        onSocket_CompleteTrip()                     // Socket On 4
        onSocket_OnTheWayBookLater()                // Socket On 5
        onSocket_AskForTips()                       // Socket On 6
        onSocket_CancelledBookingRequestBySystem()  // Socket On 7
        onSocket_CancelTrip()                       // Socket On 8
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket Emit Methods ---
    // ----------------------------------------------------

    // Socket Emit 1
    func emitSocket_UpdateCustomerLatLng(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.UpdateCustomerLatLng.rawValue, with: param)
    }
    
    // Socket Emit 2
    func emitSocket_GetEstimateFare(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.GetEstimateFare.rawValue, with: param)
    }
    
    // Socket Emit 3
    func emitSocket_ReceiveTips(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.ReceiveTips.rawValue, with: param)
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket On Methods ---
    // ----------------------------------------------------
    
    // Socket On 1
    func onSocket_GetEstimateFare() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.GetEstimateFare.rawValue) { (json) in
            print(#function, "\n ", json)
//            AlertMessage.showMessageForSuccess("Get Estimate Fare")
            
            let model = GetEstimateFareModel(fromJson: json.array?.first)
            self.estimateData = model.estimateFare
            if self.estimateData.count != 0 {                
                (self.children.first as! CarCollectionViewController).getDataFromJSON()
            }
        }
    }
    
    // Socket On 2
    func onSocket_AfterDriverAcceptRequest() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AfterDriverAcceptRequest.rawValue) { (json) in
            print(#function, "\n ", json)
            
            AlertMessage.showMessageForSuccess("Request Accepted")
            
//            let fr = json.array?.first
//            let res = RequestAcceptedDataModel(fromJson: fr)
//
//            self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
//            self.hideAndShowView(view: .requestAccepted)
//            self.isExpandCategory = true
            
             self.acceptRequestData(json: json)
        }
    }
    
    // Socket On 3
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Trip Started")
            
            self.startedRequestData(json: json)
            
//            if self.booingInfo.toDictionary().count == 0 {
//                let fr = json.array?.first
//                let res = RequestAcceptedDataModel(fromJson: fr)
//                self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
//            }
//            self.hideAndShowView(view: .rideStart)
//            self.isExpandCategory = true
            
        }
    }
    
    // Socket On 4
    func onSocket_CompleteTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CompleteTrip.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Trip Completed")
            
            self.hideAndShowView(view: .ratings)
            self.isExpandCategory = true
            
//            let alert = UIAlertController(title: AppName.kAPPName, message: "Your trip has been completed", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
//
//                self.setupAfterComplete()
//            }
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Socket On 5
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.OnTheWayBookLater.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Driver is on the way")
            
            self.acceptRequestData(json: json)
            
//            let fr = json.array?.first
//            let res = RequestAcceptedDataModel(fromJson: fr)
//            self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
//            self.hideAndShowView(view: .requestAccepted)
//            self.isExpandCategory = true
        }
    }
    
    // Socket On 6
    func onSocket_AskForTips() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AskForTips.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Driver asks for Tips")
            
            self.hideAndShowView(view: .askForTip)
            self.isExpandCategory = true
        }
    }
   
    // Socket On 7
    func onSocket_CancelledBookingRequestBySystem() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelledBookingRequestBySystem.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Cancelled Booking Request By System")
            
            self.setupAfterComplete()
        }
    }
    
    // Socket On 8
    func onSocket_CancelTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelTrip.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Cancelled Booking Request By Driver")
            
            self.setupAfterComplete()
        }
    }
    
    // -------------------------------------------------------------
    // MARK: - --- Accept Book Now & Later Data and View Setup ---
    // -------------------------------------------------------------
    func acceptRequestData(json: JSON) {
        
        let fr = json.array?.first
        let res = RequestAcceptedDataModel(fromJson: fr)
        
        self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
        self.hideAndShowView(view: .requestAccepted)
        self.isExpandCategory = true
        
        lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
    }
    
    func startedRequestData(json: JSON) {
        
        if self.booingInfo.toDictionary().count == 0 {
            let fr = json.array?.first
            let res = RequestAcceptedDataModel(fromJson: fr)
            self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
        }
        self.hideAndShowView(view: .rideStart)
        self.isExpandCategory = true
        
        lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
    }
    // MARK: -

    
}
