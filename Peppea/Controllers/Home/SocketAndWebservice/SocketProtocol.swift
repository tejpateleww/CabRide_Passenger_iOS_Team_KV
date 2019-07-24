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
    
     func onSocket_GetEstimateFare()
    
    func onSocket_AfterDriverAcceptRequest()
   
    func onSocket_StartTrip()
    
    func onSocket_CompleteTrip()
    
    func onSocket_OnTheWayBookLater()
    
}
