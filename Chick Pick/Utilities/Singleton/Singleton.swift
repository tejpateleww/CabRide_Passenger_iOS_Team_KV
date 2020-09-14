//
//  Singleton.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class SingletonClass: NSObject
{
    static let sharedInstance = SingletonClass()
    
    var RegisterOTP = String()
    var walletBalance = String()
    var BulkMilesBalance = String()
    var loginData = LoginData()
    
    var bookingInfo: BookingInfo?
    var myCurrentLocation = CLLocation()
    /// Get device token
    var token = ""
    var isChatBoxOpen = Bool()
    var ChatBoxOpenedWithID = String()
    
    var cancelReason = [CancelReason]()
    var userInfo : [String: Any]?

    func clearSingletonClass() {
        RegisterOTP = ""
        walletBalance = ""
        loginData = LoginData()
        bookingInfo = nil
       
    }
}

class SingletonRegistration: NSObject
{
    static let sharedRegistration = SingletonRegistration()
    
    var Email = String()
    var MobileNo = String()
    var Password = String()
    var FirstName = String()
    var LastName = String()
    var Document = UIImage()
}
