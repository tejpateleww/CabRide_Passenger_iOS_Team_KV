//
//  SocketAndWebservice.swift
//  Peppea
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

protocol SocketConnected {
    
    //    var isSocketConnected: Bool { get set }
    
    func emitSocket_UpdateCustomerLatLng(param: [String:Any])
    func emitSocket_GetEstimateFare(param: [String:Any])
    func emitSocket_DriverCurrentLocation(param: [String:Any])
    func emitSocket_ReceiveTips(param: [String:Any])
    func emitSocket_NearByDriver(param: [String:Any])
    func emitSocket_CancelBookingBeforeAccept(param: [String:Any])
    
    
    func onSocket_GetEstimateFare()
    
    func onSocket_AfterDriverAcceptRequest()
   
    func onSocket_StartTrip()
    
    func onSocket_CompleteTrip()
    
    func onSocket_OnTheWayBookLater()
    
    func onSocket_AskForTips()
    
    func onSocket_CancelledBookingRequestBySystem()
    
    func onSocket_CancelTrip()
    
    func onSocket_DriverCurrentLocation()
    
    func onSocket_LiveTracking()
    
    func onSocket_NearByDriver()
    
    func onSocket_ArrivedAtPickupLocation()
    
    func onSocket_VerifyCustomer()
    
    func onSocket_CompleteTripCard()
    
    func onSocket_PaymentFailedMpesa()
    
    func onSocket_PaymentSuccessMpesa()
    
    func onSocket_WaitingTimeAlert()
    
    func onSocket_CancelBookingBeforeAccept()
}
