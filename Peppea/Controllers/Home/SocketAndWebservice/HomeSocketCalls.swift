//
//  HomeSocketCalls.swift
//  Peppea
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps

extension HomeViewController: SocketConnected {
   
    
    // ----------------------------------------------------
    // MARK:- --- All Socket Methods ---
    // ----------------------------------------------------
    /// Socket On All
    func allSocketOnMethods() {
        
        onSocket_GetEstimateFare()                  // Socket On 1
        onSocket_AfterDriverAcceptRequest()         // Socket On 2
        onSocket_StartTrip()                        // Socket On 3
        onSocket_CompleteTrip()                     // Socket On 4
        onSocket_OnTheWayBookLater()                // Socket On 5
        onSocket_AskForTips()                       // Socket On 6
        onSocket_CancelledBookingRequestBySystem()  // Socket On 7
        onSocket_CancelTrip()                       // Socket On 8
        onSocket_DriverCurrentLocation()            // Socket On 9
    }
    
    /// Socket Off All
    func allSocketOffMethods() {
        
        SocketIOManager.shared.socket.off(socketApiKeys.GetEstimateFare.rawValue)                   // Socket Off 1
        SocketIOManager.shared.socket.off(socketApiKeys.AfterDriverAcceptRequest.rawValue)          // Socket Off 2
        SocketIOManager.shared.socket.off(socketApiKeys.StartTrip.rawValue)                         // Socket Off 3
        SocketIOManager.shared.socket.off(socketApiKeys.CompleteTrip.rawValue)                      // Socket Off 4
        SocketIOManager.shared.socket.off(socketApiKeys.OnTheWayBookLater.rawValue)                 // Socket Off 5
        SocketIOManager.shared.socket.off(socketApiKeys.AskForTips.rawValue)                        // Socket Off 6
        SocketIOManager.shared.socket.off(socketApiKeys.CancelledBookingRequestBySystem.rawValue)   // Socket Off 7
        SocketIOManager.shared.socket.off(socketApiKeys.CancelTrip.rawValue)                        // Socket Off 8
        SocketIOManager.shared.socket.off(socketApiKeys.DriverCurrentLocation.rawValue)             // Socket Off 9
        SocketIOManager.shared.socket.off(clientEvent: .disconnect)                                 // Socket Disconnect
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
    
    // Socket Emit 4
    func emitSocket_DriverCurrentLocation(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.DriverCurrentLocation.rawValue, with: param)
    }
    // ----------------------------------------------------
    // MARK:- --- Socket On Methods ---
    // ----------------------------------------------------
    
    // Socket On 1
    func onSocket_GetEstimateFare() {
            SocketIOManager.shared.socketCall(for: socketApiKeys.GetEstimateFare.rawValue) { (json) in
//            print(#function, "\n ", json)

            let model = GetEstimateFareModel(fromJson: json.array?.first)
                guard model.estimateFare != nil else  { return }
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
            self.clearMap()
            self.btnBackButtonWhileBookLater()
            
            AlertMessage.showMessageForSuccess("Request Accepted")
            self.stopAnimationWhileStartBooking()
            self.acceptRequestData(json: json)
        }
    }
    
    // Socket On 3
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue) { (json) in
//            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Trip Started")
            self.startedRequestData(json: json)

        }
    }
    
    // Socket On 4
    func onSocket_CompleteTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CompleteTrip.rawValue) { (json) in
//            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Trip Completed")
            
//            if self.booingInfo.toDictionary().count == 0 {
                let fr = json.array?.first
                let res = RequestAcceptedDataModel(fromJson: fr)
                self.booingInfo = res.bookingInfo
//            }
            if self.booingInfo.rentType == "bulk_miles" {
                
                if let SavedLoginData = UserDefaults.standard.value(forKey: "userProfile") as? LoginModel {
                    let balanceLoginData = SavedLoginData
                    balanceLoginData.loginData.BulkMilesBalance =  self.booingInfo.customerInfo.MilesBalance
                    balanceLoginData.loginData.walletBalance    = self.booingInfo.customerInfo.walletBalance
                    SingletonClass.sharedInstance.BulkMilesBalance = balanceLoginData.loginData.walletBalance
                    SingletonClass.sharedInstance.walletBalance = balanceLoginData.loginData.walletBalance
                    SingletonClass.sharedInstance.loginData = balanceLoginData.loginData
                    
                    do {
                        try UserDefaults.standard.set(object: balanceLoginData, forKey: "userProfile")
                        
                    }
                    catch {
                        
                    }
                }
            }
            
            
            self.hideAndShowView(view: .ratings)
            self.isExpandCategory = true

        }
    }
    
    // Socket On 5
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.OnTheWayBookLater.rawValue) { (json) in
//            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Driver is on the way")
            
            self.acceptRequestData(json: json)
        }
    }
    
    // Socket On 6
    func onSocket_AskForTips() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AskForTips.rawValue) { (json) in
//            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Driver asks for Tips")
            
            self.hideAndShowView(view: .askForTip)
            self.isExpandCategory = true
        }
    }
   
    // Socket On 7
    func onSocket_CancelledBookingRequestBySystem() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelledBookingRequestBySystem.rawValue) { (json) in
//            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Cancelled Booking Request By System")
            
//            self.clearMap()
            self.btnBackButtonWhileBookLater()
            self.stopAnimationWhileStartBooking()
//            self.setupAfterComplete()
        }
    }
    
    // Socket On 8
    func onSocket_CancelTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelTrip.rawValue) { (json) in
//            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Cancelled Booking Request By Driver")
            self.clearMap()
            self.btnBackButtonWhileBookLater()
            self.stopAnimationWhileStartBooking()
//            self.setupAfterComplete()
        }
    }
    
    // Socket On 9
    func onSocket_DriverCurrentLocation() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.DriverCurrentLocation.rawValue) { (json) in
            print(#function, "\n ", json)

            let arrData =  json.array?.first?["current_location"].array


            self.liveTrackingForTrip(lat: arrData?.last?.stringValue ?? "0.00", lng: arrData?.first?.stringValue ?? "0.00")
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
        self.routeDrawMethod(origin: "\(res.bookingInfo.driverInfo.lat ?? ""),\(res.bookingInfo.driverInfo.lng ?? "")", destination: "\(res.bookingInfo.pickupLat ?? ""),\(res.bookingInfo.pickupLng ?? "")", isTripAccepted: true)
        if self.driverMarker == nil {
                        
            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = res.bookingInfo.driverInfo?.lat, let doubleLat = Double(lat) {
                DoubleLat = doubleLat
            }
            
            if let lng = res.bookingInfo.driverInfo?.lng, let doubleLng = Double(lng) {
                DoubleLng = doubleLng
            }
            
            let DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            self.driverMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
            self.driverMarker.icon = UIImage(named: iconCar)
            self.driverMarker.map = self.mapView
        }
        else {
            self.driverMarker.icon = UIImage.init(named: iconCar)
        }
        markerContainerView.isHidden = true
        lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
    }
    
    func startedRequestData(json: JSON) {
        
        if self.booingInfo.toDictionary().count == 0 {
            let fr = json.array?.first
            let res = RequestAcceptedDataModel(fromJson: fr)
            self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
//            setupCarMarker(res: res.bookingInfo)
            self.routeDrawMethod(origin: "\(res.bookingInfo.pickupLat ?? ""),\(res.bookingInfo.pickupLng ?? "")", destination: "\(res.bookingInfo.dropoffLat ?? ""),\(res.bookingInfo.dropoffLng ?? "")", isTripAccepted: true)
            
        }
        self.hideAndShowView(view: .rideStart)
        self.isExpandCategory = true
        
        lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
    }
    
    func stopAnimationWhileStartBooking() {
        self.mapView.animate(toViewingAngle: 0)
        self.mapView.animate(toZoom: zoomLevel)
//        self.mapView.isMyLocationEnabled = true
        self.btnCurrentLocation(UIButton())
        UtilityClass.hideHUD()
    }
}
