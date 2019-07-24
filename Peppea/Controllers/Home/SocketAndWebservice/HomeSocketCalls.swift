//
//  HomeSocketCalls.swift
//  Peppea
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation


extension HomeViewController: SocketConnected {

    
    
    func allSocketOnMethods() {
        
        onSocket_GetEstimateFare()
        onSocket_AfterDriverAcceptRequest()
        onSocket_StartTrip()
        onSocket_CompleteTrip()
        onSocket_OnTheWayBookLater()
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket Emit Methods ---
    // ----------------------------------------------------

    
    func emitSocket_UpdateCustomerLatLng(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.UpdateCustomerLatLng.rawValue, with: param)
    }
    
    func emitSocket_GetEstimateFare(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.GetEstimateFare.rawValue, with: param)
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket On Methods --- 
    // ----------------------------------------------------
    
    func onSocket_GetEstimateFare() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.GetEstimateFare.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Get Estimate Fare")
            
            let model = GetEstimateFareModel(fromJson: json)
            self.estimateData = model.estimateFare
        }
    }
    
    func onSocket_AfterDriverAcceptRequest() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AfterDriverAcceptRequest.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Request Accepted")
        }
    }
    
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Trip Started")
        }
    }
    
    func onSocket_CompleteTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CompleteTrip.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Trip Completed")
        }
    }
    
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.OnTheWayBookLater.rawValue) { (json) in
            print(#function, "\n ", json)
            AlertMessage.showMessageForSuccess("Driver is on the way")
        }
    }
    
    
}
