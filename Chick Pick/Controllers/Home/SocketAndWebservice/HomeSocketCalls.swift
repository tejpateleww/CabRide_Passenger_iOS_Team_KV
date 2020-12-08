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
        onSocket_LiveTracking()                     // Socket On 9
        onSocket_DriverCurrentLocation()            // Socket On 10
        onSocket_NearByDriver()                     // Socket On 11
        onSocket_ArrivedAtPickupLocation()          // Socket On 12
        onSocket_VerifyCustomer()                   // Socket On 13
        onSocket_CompleteTripCard()                 // Socket On 14
        onSocket_PaymentFailedMpesa()               // Socket On 15
        onSocket_PaymentSuccessMpesa()              // Socket On 16
        onSocket_WaitingTimeAlert()                 // Socket On 17
        onSocket_CancelBookingBeforeAccept()        // Socket On 18
        onSocket_VerifyEndTrip()                    // Socket On 19
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
        SocketIOManager.shared.socket.off(socketApiKeys.LiveTracking.rawValue)                      // Socket Off 9
        SocketIOManager.shared.socket.off(socketApiKeys.DriverCurrentLocation.rawValue)             // Socket Off 10
        SocketIOManager.shared.socket.off(socketApiKeys.NearByDriver.rawValue)                      // Socket Off 11
        SocketIOManager.shared.socket.off(socketApiKeys.ArrivedAtPickupLocation.rawValue)           // Socket Off 12
        SocketIOManager.shared.socket.off(socketApiKeys.VerifyCustomer.rawValue)                    // Socket Off 13
        SocketIOManager.shared.socket.off(socketApiKeys.CompleteTripCard.rawValue)                  // Socket Off 14
        SocketIOManager.shared.socket.off(socketApiKeys.PaymentFailedMpesa.rawValue)                // Socket Off 15
        SocketIOManager.shared.socket.off(socketApiKeys.PaymentSuccessMpesa.rawValue)               // Socket Off 16
        SocketIOManager.shared.socket.off(socketApiKeys.WaitingTimeAlert.rawValue)                  // Socket Off 17
        SocketIOManager.shared.socket.off(socketApiKeys.CancelBookingBeforeAccept.rawValue)         // Socket Off 18
        SocketIOManager.shared.socket.off(socketApiKeys.VerifyEndTrip.rawValue)                     // Socket Off 19
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
    
    // Socket Emit 5
    func emitSocket_NearByDriver(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.NearByDriver.rawValue, with: param)
         print(#function)
    }
    
    // Socket Emit 6
    func emitSocket_CancelBookingBeforeAccept(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.CancelBookingBeforeAccept.rawValue, with: param)
    }
    
    
    // ----------------------------------------------------
    // MARK:- --- Socket On Methods ---
    // ----------------------------------------------------
    
    // Socket On 1
    func onSocket_GetEstimateFare() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.GetEstimateFare.rawValue) { (json) in
                        print(#function, "\n ", json)

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
//            self.viewMainActivityIndicator.isHidden = true
//            self.viewActivityAnimation.stopAnimating()
            
            if let preserntVC = self.presentedViewController as? RequestLodingViewController {
                preserntVC.dismiss(animated: true, completion: nil)
            }
            
            self.clearMap()
            self.btnBackButtonWhileBookLater()
            AlertMessage.showMessageForSuccess(json.array?.first?.dictionary?["message"]?.string ?? "Request Accepted")
            self.stopAnimationWhileStartBooking()
            self.acceptRequestData(json: json, isBookLaterAccept: true)
            self.stopNearByDriverTimer()
        }
    }
    
    // Socket On 3
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue) { (json) in
            print(#function, "\n ", json)
//            AlertMessage.showMessageForSuccess("Trip Started")
            AlertMessage.showMessageForSuccess(json.array?.first?.dictionary?["message"]?.string ?? "Trip Started")
            self.startedRequestData(json: json)
            self.stopNearByDriverTimer()
        }
    }
    
    // Socket On 4
    func onSocket_CompleteTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CompleteTrip.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess(json.array?.first?.dictionary?["message"]?.string ?? "Trip Completed")
            
            //            if self.booingInfo.toDictionary().count == 0 {
            let fr = json.array?.first
            let res = RequestAcceptedDataModel(fromJson: fr)
            self.booingInfo = res.bookingInfo
            self.clearMap()
            //            }
            if self.booingInfo.rentType == "bulk_miles" {
                
                if let SavedLoginData = UserDefaults.standard.value(forKey: "userProfile") as? LoginModel {
                    let balanceLoginData = SavedLoginData
                    balanceLoginData.loginData.BulkMilesBalance =  self.booingInfo.customerInfo.milesBalance
                    balanceLoginData.loginData.walletBalance    = self.booingInfo.customerInfo.walletBalance
                    SingletonClass.sharedInstance.BulkMilesBalance = balanceLoginData.loginData.walletBalance
                    SingletonClass.sharedInstance.walletBalance = balanceLoginData.loginData.walletBalance
                    SingletonClass.sharedInstance.loginData = balanceLoginData.loginData
                    SingletonClass.sharedInstance.bookingInfo = self.booingInfo
                    do {
                        try UserDefaults.standard.set(object: balanceLoginData, forKey: "userProfile")
                    }
                    catch {
                        print("ERROR " , #file, "\t Line: ", #line, " \(error.localizedDescription)")
                    }
                }
            }
//            self.hideAndShowView(view: .ratings)
            self.hideAndShowView(view: .completeTrip)
            self.isExpandCategory = true
        }
    }
    
    // Socket On 5
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.OnTheWayBookLater.rawValue) { (json) in
            print(#function, "\n ", json)
//            AlertMessage.showMessageForSuccess("Driver is on the way")
            AlertMessage.showMessageForSuccess(json.array?.first?.dictionary?["message"]?.string ?? "Driver is on the way")
            self.acceptRequestData(json: json, isBookLaterAccept: false)
        }
    }
    
    // Socket On 6
    func onSocket_AskForTips() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AskForTips.rawValue) { (json) in
            print(#function, "\n ", json)
//            AlertMessage.showMessageForSuccess("Driver asks for Tips")
            self.hideAndShowView(view: .askForTip)
            self.isExpandCategory = true
        }
    }

    // Socket On 7
    func onSocket_CancelledBookingRequestBySystem() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelledBookingRequestBySystem.rawValue) { (json) in
            print(#function, "\n ", json)
//            AlertMessage.showMessageForSuccess("Cancelled Booking Request By System")
            AlertMessage.showMessageForSuccess(json.array?.first?.dictionary?["message"]?.string ?? "Cancelled Booking Request By System")
            //            self.clearMap()
            self.btnBackButtonWhileBookLater()
            self.stopAnimationWhileStartBooking()
            self.setupAfterComplete()
            self.viewMainActivityIndicator.isHidden = true
            self.viewActivityAnimation.stopAnimating()
            
            if let preserntVC = self.presentedViewController as? RequestLodingViewController {
                preserntVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Socket On 8
    func onSocket_CancelTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelTrip.rawValue) { (json) in
            print(#function, "\n ", json)
//            AlertMessage.showMessageForSuccess("Cancelled Booking Request By Driver")
            AlertMessage.showMessageForSuccess(json.array?.first?.dictionary?["message"]?.string ?? "Cancelled Booking Request By Driver")
            self.clearMap()
            self.btnBackButtonWhileBookLater()
            self.stopAnimationWhileStartBooking()
            self.setupAfterComplete()
            self.viewMainActivityIndicator.isHidden = true
            self.viewActivityAnimation.stopAnimating()
            if let preserntVC = self.presentedViewController as? RequestLodingViewController {
                preserntVC.dismiss(animated: true, completion: nil)
            }
            self.startNearByDriverTimer()
        }
    }
    
    // Socket On 9
    func onSocket_LiveTracking() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.LiveTracking.rawValue) { (json) in
            print(#function, "\n ", json)

            let arrData = json.array?.first?["current_location"].array
            self.liveTrackingForTrip(lat: arrData?.last?.stringValue ?? "0.00", lng: arrData?.first?.stringValue ?? "0.00")
        }
    }
    
    // Socket On 10
    func onSocket_DriverCurrentLocation() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.DriverCurrentLocation.rawValue) { (json) in
            print(#function, "\n ", json)
            
        }
    }
    
    // Socket On 11
    func onSocket_NearByDriver() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.NearByDriver.rawValue) { (json) in
            print(#function, "\n ", json)
            let model = NearByDriversModel(fromJson: json)
            self.nearByDrivers = model.drivers
        }
    }
    
    // Socket On 12
    func onSocket_ArrivedAtPickupLocation() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.ArrivedAtPickupLocation.rawValue) { (json) in
            print(#function, "\n ", json)
            
            let messsage = json.array?.first?.dictionary?["message"]?.string ?? "Arrived at pickup location"
            UtilityClass.showDefaultAlertView(withTitle: "", message: messsage, buttons: ["Ok"], completion: { (ind) in
            })
        }
    }

    // Socket On 13
    func onSocket_VerifyCustomer() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.VerifyCustomer.rawValue) { (json) in
            print(#function, "\n ", json)
            
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            let msg = json.array?.first?.dictionary?["message2"]?.string ?? ""
            let otp = json.array?.first?.dictionary?["otp"]?.string ?? ""
            
            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "VerifyCustomerPopupViewController") as? VerifyCustomerPopupViewController {
                vc.strMessage = msg
                vc.strTitle = titleMessage
                vc.strOTP = otp
                vc.strBtnTitle = "Done"
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // Socket On 14
    func onSocket_CompleteTripCard() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CompleteTripCard.rawValue) { (json) in
            print(#function, "\n ", json)
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            AlertMessage.showMessageForSuccess(titleMessage)
        }
    }
    
    // Socket On 15
    func onSocket_PaymentFailedMpesa() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.PaymentFailedMpesa.rawValue) { (json) in
            print(#function, "\n ", json)
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            AlertMessage.showMessageForSuccess(titleMessage)
        }
    }
    // Socket On 16
    func onSocket_PaymentSuccessMpesa() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.PaymentSuccessMpesa.rawValue) { (json) in
            print(#function, "\n ", json)
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            AlertMessage.showMessageForSuccess(titleMessage)
        }
    }
    
    // Socket On 17
    func onSocket_WaitingTimeAlert() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.WaitingTimeAlert.rawValue) { (json) in
            print(#function, "\n ", json)
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            AlertMessage.showMessageForSuccess(titleMessage)
        }
    }
    
    // Socket On 18
    func onSocket_CancelBookingBeforeAccept() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelBookingBeforeAccept.rawValue) { (json) in
            print(#function, "\n ", json)
            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            AlertMessage.showMessageForSuccess(titleMessage)
            self.viewMainActivityIndicator.isHidden = true
            self.viewActivityAnimation.stopAnimating()
            if let preserntVC = self.presentedViewController as? RequestLodingViewController {
                preserntVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    // Socket On 19
    func onSocket_VerifyEndTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.VerifyEndTrip.rawValue) { (json) in
            print(#function, "\n ", json)

            let titleMessage = json.array?.first?.dictionary?["message"]?.string ?? ""
            let msg = json.array?.first?.dictionary?["message2"]?.string ?? ""
            let otp = json.array?.first?.dictionary?["otp"]?.string ?? ""

            let storyboard = UIStoryboard(name: "Popup", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "VerifyCustomerPopupViewController") as? VerifyCustomerPopupViewController {
                vc.strMessage = msg
                vc.strTitle = titleMessage
                vc.strOTP = otp
                vc.strBtnTitle = "Done"
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // -------------------------------------------------------------
    // MARK: - --- Accept Book Now & Later Data and View Setup ---
    // -------------------------------------------------------------
    func acceptRequestData(json: JSON, isBookLaterAccept: Bool) {
        
        let fr = json.array?.first
        let res = RequestAcceptedDataModel(fromJson: fr)
        
        self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
        if isBookLaterAccept && self.booingInfo.bookingType == "book_later" {
            self.hideAndShowView(view: .booking)
            UtilityClass.showDefaultAlertView(withTitle: "", message: "Your booking request has been confirmed", buttons: ["Ok"], completion: { (ind) in
            })
            print("Book Later Ride accepted")
        } else if self.booingInfo.bookingType == "book_later" && self.booingInfo.status == "accepted" {
            UtilityClass.showDefaultAlertView(withTitle: "", message: "Your driver is on the way for trip (ID: \(self.booingInfo.id ?? ""))", buttons: ["Ok"], completion: { (ind) in
            })
            self.hideAndShowView(view: .requestAccepted)
            print("Driver is On The Way")
        } else {
            self.hideAndShowView(view: .requestAccepted)
        }
       
        self.isExpandCategory = true
        self.routeDrawMethod(origin: "\(res.bookingInfo.driverInfo.lat ?? ""),\(res.bookingInfo.driverInfo.lng ?? "")", destination: "\(res.bookingInfo.pickupLat ?? ""),\(res.bookingInfo.pickupLng ?? "")", isTripAccepted: true)
        if self.pickupMarker?.map == nil {

            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = res.bookingInfo.driverInfo?.lat, let doubleLat = Double(lat) {
                DoubleLat = doubleLat
            }
            
            if let lng = res.bookingInfo.driverInfo?.lng, let doubleLng = Double(lng) {
                DoubleLng = doubleLng
            }
            
            let DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            self.pickupMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
            self.pickupMarker?.icon = UIImage(named: iconCar)
            self.pickupMarker?.map = self.mapView
        }
        else {
            self.pickupMarker?.icon = UIImage.init(named: iconCar)
        }
        markerContainerView.isHidden = true
        lblBuildNumber.text = "Build : \(Bundle.main.buildVersionNumber ?? "") \t\t Booking ID: \(self.booingInfo.id ?? "")"
    }
    
    func startedRequestData(json: JSON) {

        let fr = json.array?.first
        let res = RequestAcceptedDataModel(fromJson: fr)
        self.booingInfo = res.bookingInfo // BookingInfo(fromJson: json.arrayValue.first)
        self.routeDrawMethod(origin: "\(res.bookingInfo.pickupLat ?? ""),\(res.bookingInfo.pickupLng ?? "")", destination: "\(res.bookingInfo.dropoffLat ?? ""),\(res.bookingInfo.dropoffLng ?? "")", isTripAccepted: true)
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
