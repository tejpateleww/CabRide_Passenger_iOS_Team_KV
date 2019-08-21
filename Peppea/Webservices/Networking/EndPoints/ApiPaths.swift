//
//  ApiPaths.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 20/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit


typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum NetworkEnvironment: String {
   
    case qa = "https://www.peppea.com/panel/api/customer_api/"// "http://13.127.213.134/panel/api/customer_api/"
    //http://13.127.213.134/panel
    
    case imageURL = "https://www.peppea.com/panel/"
    
    static var baseURL : String{
        return NetworkEnvironment.environment.rawValue
    }
    
    static var baseImageURL : String{
        return NetworkEnvironment.imageURL.rawValue
    }
    
    static var headers : [String:String]
    {
        
        if UserDefaults.standard.object(forKey: "isUserLogin") != nil {
            
            if UserDefaults.standard.object(forKey: "isUserLogin") as? Bool == true {
                
                var loginModelDetails: LoginModel = LoginModel()
                do {
                    loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
                    if loginModelDetails.loginData.xApiKey != nil
                    {
                        return ["key":"Peppea$951", "x-api-key": loginModelDetails.loginData.xApiKey]
                    }
                    else
                    {
                        return ["key":"Peppea$951"]
                    }
                } catch {
                    AlertMessage.showMessageForError("error")
                    return ["key":"Peppea$951"]
                }
            }
        }
        
        return ["key":"Peppea$951"]
    }
   
    static var environment: NetworkEnvironment{
        //Set environment Here
        return .qa
    }
   
    static var token: String{
        return "dhuafidsuifunabneufjubefg"
    }
}

enum ApiKey: String{
    case Init = "init/"
    case login = "login"
    case otp = "register_otp"
    case docUpload = "upload_docs"
    case register = "register"
    case fixRateList = "fix_rate_list"
    case transferMoney = "transfer_money"
    case transferMoneyToBank = "transfer_money_to_bank"
    case AddCard = "add_card"
    case cardList = "card_list"
    case AddMoney = "add_money"
    case removeCard = "remove_card"
    case updateAccount = "update_bank_info"
    case updateBasicInfo = "update_basic_info"
    case changePassword = "change_password"
    case forgotPassword = "forgot_password"
    case walletHistory = "wallet_history"
    case profileUpdate = "profile_update"
    case logout = "logout/"
    
    
    case QRCodeDetail = "qr_code_detail"
    case BookingRequest = "booking_request"
    case PastBookingHistory = "past_booking_history/"
    case MobileNoDetail = "transfer_money_with_mobile_no" // "mobile_no_detail"
    case checkPromocode = "check_promocode"
    
    case ReviewRating = "review_rating"
    case CancelTrip = "cancel_trip"
    case upcomingBookingHistory = "upcoming_booking_history/"
    case GetBulkMileList = "bulk_miles_list"
    case PurchaseBulkMile = "bulk_miles_purchase"
    case BulkMilesHistory = "bulk_miles_booking_history/"
    
    case favouriteAddressList = "favourite_address_list/"
    case addFavouriteAddress = "add_favourite_address"
    case removeFavouriteAddress = "remove_favourite_address"
}
enum ParameterKey
{
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let categoryId = "CategoryId"
    static let page = "Page"
    static let sortBy = "Sortby"
    static let filter = "Filter"
}

enum socketApiKeys: String
{
    
    case kSocketBaseURL = "https://www.peppea.com:8080" // "http://13.127.213.134:8080" //"https://www.tantaxitanzania.com:8081""http://3.120.161.225:8080""http://13.237.0.107:8080/"http://3.120.161.225:8080""https://pickngolk.info:8081" "https://pickngolk.info:8081"   // "http://54.169.67.226:8080"  //
    
    case UpdateCustomerLatLng       = "connect_customer"    // customer_id, lat, lng
    case GetEstimateFare            = "get_estimate_fare"   // customer_id : 1, pickup_lng:72.5291184, dropoff_lat:23.0305179, dropoff_lng:72.5053514, pickup_lat:23.0636726
    case AfterDriverAcceptRequest   = "accept_booking_request"
    case StartTrip                  = "start_trip"
    case CompleteTrip               = "complete_trip"
    case OnTheWayBookLater          = "on_the_way_booking_request"
    
    case AskForTips                 = "ask_for_tips"
    case ReceiveTips                = "receive_tips"    // booking_id,tips
    case CancelledBookingRequestBySystem = "cancelled_booking_request_by_system"
    case CancelTrip                 = "cancel_trip"
    case DriverCurrentLocation      = "driver_current_location"
}






