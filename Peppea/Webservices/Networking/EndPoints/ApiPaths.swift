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
   
    case qa = "http://13.127.213.134/panel/api/customer_api/"
    //http://13.127.213.134/panel
    static var baseURL : String{
        return NetworkEnvironment.environment.rawValue
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
    case MobileNoDetail = "mobile_no_detail"
    case checkPromocode = "check_promocode"
    
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
    
    case kSocketBaseURL = "http://13.127.213.134:8080" //"https://www.tantaxitanzania.com:8081""http://3.120.161.225:8080""http://13.237.0.107:8080/"http://3.120.161.225:8080""https://pickngolk.info:8081" "https://pickngolk.info:8081"   // "http://54.169.67.226:8080"  //
    
}






