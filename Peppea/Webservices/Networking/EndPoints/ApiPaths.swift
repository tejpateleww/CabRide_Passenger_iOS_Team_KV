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
   
    case liveBaseUrl = "https://www.peppea.com/panel/api/customer_api/"

    case developmentBaseUrl = "https://www.peppea.com/panel/api/customer_api2/"


    case imageURL = "https://www.peppea.com/panel/"
    
    static var baseURL : String{
        return NetworkEnvironment.environment.rawValue
    }
    
    static var baseImageURL : String{
        return NetworkEnvironment.imageURL.rawValue
    }
    
    static var headers : [String:String]
    {
        
        if UserDefaults.standard.object(forKey: "userProfile") != nil {
            if UserDefaults.standard.object(forKey: "isUserLogin") != nil {
                
                if UserDefaults.standard.object(forKey: "isUserLogin") as? Bool == true {
                    
                    var loginModelDetails: LoginModel = LoginModel()
                    
                    do {
                        loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
                        if loginModelDetails.loginData.xApiKey != nil
                        {
                            print("Header Key : \t\(["key":"Peppea$951", "x-api-key": loginModelDetails.loginData.xApiKey])")
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
        }
        
        return ["key":"Peppea$951"]
    }
   
    static var environment: NetworkEnvironment{
        //Set environment Here

//        #if DEBUG
//        return .developmentBaseUrl
//        #else
        return .liveBaseUrl
//        #endif


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
    case getRegisteredCompanyList = "registered_company_list"
    case register = "register"
    case fixRateList = "fix_rate_list"
    case transferMoney = "transfer_money"
    case transferMoneyToBank = "transfer_money_to_bank"
    case withdrawals = "withdrawals"
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
    case CurrentTripDetails = "ongoing_booking_history/"
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
    
    case transferCorporateMiles = "transfer_corporate_miles/"
    
    case customerUnderCompanyList = "customer_under_company_list/"
    
    case pastDueHistory = "past_due_history/"
    case pastDuePayment = "past_due_payment"
    case chat = "chat"
    case chatHistory = "chat_history/"
    
    case generateTicket = "generate_ticket"
    case ticketList = "ticket_list/"
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
    
    /// **** Emit Keys ****
    case UpdateCustomerLatLng       = "connect_customer"    // customer_id, lat, lng
    case ReceiveTips                = "receive_tips"    // booking_id,tips
    //---------------------------------------------------------------------------------
    
    /// **** ON/Emit Keys ****
    case GetEstimateFare            = "get_estimate_fare"   // customer_id : 1, pickup_lng:72.5291184, dropoff_lat:23.0305179, dropoff_lng:72.5053514, pickup_lat:23.0636726
    case DriverCurrentLocation      = "driver_current_location"
    case NearByDriver               = "near_by_driver"
    case CancelBookingBeforeAccept  = "cancel_booking_before_accept"
    //---------------------------------------------------------------------------------
    
    /// **** On Keys ****
    case AfterDriverAcceptRequest   = "accept_booking_request"
    case StartTrip                  = "start_trip"
    case CompleteTrip               = "complete_trip"
    case OnTheWayBookLater          = "on_the_way_booking_request"
    case AskForTips                 = "ask_for_tips"
    case CancelledBookingRequestBySystem = "cancelled_booking_request_by_system"
    case CancelTrip                 = "cancel_trip"
    case LiveTracking               = "live_tracking"       //"driver_current_location"\
    case ArrivedAtPickupLocation    = "arrived_at_pickup_location"
    
    case VerifyCustomer             = "verify_customer"
    case VerifyEndTrip              = "request_code_for_complete_trip"
    case CompleteTripCard           = "complete_trip_card"
    case PaymentFailedMpesa         = "payment_failed_mpesa"
    case PaymentSuccessMpesa        = "payment_success_mpesa"
    case WaitingTimeAlert           = "waiting_time_alert"
    //---------------------------------------------------------------------------------
}

//Common.socket.on(Socket.EVENT_CONNECT, onConnect);
//Common.socket.on("accept_booking_request", onAcceptBookingRequestNotification);  // accept booking request
//Common.socket.on("cancel_trip", onRejectBookingRequestNotification); // cancel trip
//Common.socket.on("cancelled_booking_request_by_system", onRejectBookingRequestNotification); //Do not accept Any Driver
//Common.socket.on("complete_trip", completeTrip);                                //Complete Trip
//Common.socket.on("start_trip", onPickupPassengerNotification);                  //start trip
//Common.socket.on("ask_for_tips", AskForTipsToPassenger);                        // Ask for tip
//Common.socket.on("get_estimate_fare", onGetEstimateFare);                                   // get Car models
//Common.socket.on("on_the_way_booking_request", onAcceptAdvancedBookingRequestNotification);  //  On the Way Book later
//Common.socket.on("live_tracking"/*"driver_current_location"*/, onGetDriverLocation);  //  Get Driver location
//Common.socket.on("complete_trip_card", onLoadPayment);  //  if 3D CARD load web page for enter otp
//Common.socket.on("arrived_at_pickup_location", onArrivedDriver);
//Common.socket.on("near_by_driver", onReceiveNearByDriver);
//Common.socket.on("payment_failed_mpesa", onMpesaPaymentFailed);
//Common.socket.on("payment_success_mpesa", onMpesaPaymentSuccess);
//Common.socket.on("waiting_time_alert", onWaitting_time_alert);
//Common.socket.on("cancel_booking_before_accept", onCancelBookingBeforeAccept);
//Common.socket.on("verify_customer", onVerifyCustomer);
//Common.socket.on(Socket.EVENT_DISCONNECT, onDisconnect);
