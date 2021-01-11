//
//  Constants.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit


//Orange : e38428
//Grey : 9a9a9a
//Balck : 2e2d2e

let headerKey = "Chickpick$951"

let peppeaAppNameString = "Chick Pick"
let peppeaRentalAppNameString = "PeppeaRental"

let googlApiKey = "AIzaSyDbeyMFesrTnaEqiiHsuRMPLaVbT_ZhVe8" // -> Chick Pick
//let googlApiKey = "AIzaSyBljwkxcq9BemGT2xZfagE6AY9QhBCN4I8" -> Peppea

// "AIzaSyAU93jU-DaBHNEI0m-goQ5yB8-B8GZVDTs"//given by Mayur panchal//"AIzaSyD5Z5jg7XlOwdC_Cd0HYa4LWJl9pPyEpnY" // "AIzaSyDcug87uBhFLMo1KlqyaO10shE-sNTBCmw" // built from ODDs

let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
let geocodeAddress = "https://maps.googleapis.com/maps/api/geocode/json?latlng="

let PaymentSuccessURL = "https://www.peppea.com/panel/flutterwave/payment_success"
let PaymentFailureURL = "https://www.peppea.com/panel/flutterwave/payment_failed"


//var imagBaseURL = "https://www.peppea.com/panel/"

let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
let kAppBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]  as! String


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let Currency = "£"
let MeasurementSign = "mi"
let helpLine = "1234567890"

let ThemeColor : UIColor =  UIColor.init(hex: "01010b")
let ThemeOrange: UIColor = UIColor.init(hex: "e795df")

let cellBorderColor: UIColor = UIColor.init(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0)
let NotificationSetHomeVC = NSNotification.Name(rawValue:"NotificationSetHomeVC")

let iconCar = "iconCar"
let iconMarker = "iconMarker"
let zoomLevel: Float = 16.0


// Notifications Observers
struct NotificationsKey {
    static let UpdateChatNotification = Notification.Name("UpdateChat")
}
