//
//  UserWebserviceSubclass.swift
//  Chick Pick
//
//  Created by Mayur iMac on 08/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

class UserWebserviceSubclass
{
    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)//requestMethod(api: .update, httpMethod: .get, parameters: strType, completion: completion)
    }
//    class func register( registerModel : RegistrationModel , image: UIImage, imageParamName: String ,completion: @escaping CompletionResponse ) {
//        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
//        WebService.shared.postDataWithImage(api: .register, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
//    }
    
    class func register( registerModel : RegistrationModel ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .register, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func login( loginModel : loginModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .login, httpMethod: .post, parameters: params, completion: completion)
    }
    class func forgotPassword( ForgotPasswordModel : ForgotPassword  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = ForgotPasswordModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .forgotPassword, httpMethod: .post, parameters: params, completion: completion)
    }
    class func changePassword( ChangePasswordModel : ChangePassword  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = ChangePasswordModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func updatePersonal(updateProfile : UpdatePersonalInfo, image: UIImage, imageParamName: String, completion: @escaping CompletionResponse)
    {
        let params : [String: String] = updateProfile.generatPostParams() as! [String:String]
        WebService.shared.postDataWithImage(api: .profileUpdate, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
    }
    
    class func addCardInList(addCardModel : AddCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = addCardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddCard, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CardInList(cardListModel : CardList, completion: @escaping CompletionResponse) {
        let params : [String:String] = cardListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .cardList, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func RemoveCardFromList(removeCardModel : RemoveCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = removeCardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .removeCard, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func Logout( strURL : String  ,completion: @escaping CompletionResponse )
    {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.logout.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    // ----------------------------------------  Peppea API ----------------------------------------------
    
    
    class func getRegisteredCompanyList( strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.getRegisteredCompanyList.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func AddMoneytoWallet(addMoneyModel : AddMoney, completion: @escaping CompletionResponse) {
        let params : [String:String] = addMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddMoney, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferMoney(transferMoneyModel : TransferMoneyModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .transferMoney, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferMoneyToBank(transferMoneyToBankModel : transferMoneyToBank, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyToBankModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .transferMoneyToBank, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferMoneyToMPesa(transferMoneyToMpesaModel : transferMoneyToMpesa, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyToMpesaModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .withdrawals, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func updateAccount(transferMoneyModel : UpdateAccountData, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateAccount, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func scanCodeDetail(QRCodeDetailsModel : QRCodeDetails, completion: @escaping CompletionResponse) {
        let params : [String:String] = QRCodeDetailsModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .QRCodeDetail, httpMethod: .post, parameters: params, completion: completion)
    }
    class func MobileNoDetailDetail(MobileNoDetailModel : MobileNoDetail, completion: @escaping CompletionResponse) {
        let params : [String:String] = MobileNoDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .MobileNoDetail, httpMethod: .post, parameters: params, completion: completion)
    }
    
    
    class func walletHistoryList( WalletHistoryModel : WalletHistory  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = WalletHistoryModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .walletHistory, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func getFixRateList( strURL : String  ,completion: @escaping CompletionResponse )
    {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.fixRateList.rawValue
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func bookingRequest( bookingRequestModel : bookingRequest  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = bookingRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .BookingRequest, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func pastBookingHistory( strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.PastBookingHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func CancelTripBookingRequest( bookingRequestModel : CancelTripRequestModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = bookingRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .CancelTrip, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func ReviewRatingToDriver( bookingRequestModel : ReviewRatingReqModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = bookingRequestModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .ReviewRating, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func upcomingBookingHistory(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.upcomingBookingHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    
    class func currentBookingList(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.CurrentTripDetails.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    
    class func checkPromocodeService(Promocode : CheckPromocode  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Promocode.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .checkPromocode, httpMethod: .post, parameters: params, completion: completion)
    }
    
    
    class func getBulkMile( strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.GetBulkMileList.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    
    class func BulkMilesBookingHistory(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.BulkMilesHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func PurchaseBulkMile( PurchaseRequest : BulkMilesPurchase, completion: @escaping CompletionResponse) {
        let  params : [String:String] = PurchaseRequest.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .PurchaseBulkMile, httpMethod: .post , parameters: params, completion: completion)
    }
    
    class func favouriteAddressListService( strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.favouriteAddressList.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func addFavouriteAddressListService(Promocode : addFavouriteAddressReqModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Promocode.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .addFavouriteAddress, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func deleteFavouriteAddressListService(Promocode : deleteFavouriteAddressReqAddress  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Promocode.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .removeFavouriteAddress, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferCorporateMiles(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.transferCorporateMiles.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func customerUnderCompanyList(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.customerUnderCompanyList.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func SendMessageToDriver(SendChat:chatModel , completion: @escaping CompletionResponse) {
        let  params : [String:String] = SendChat.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .removeFavouriteAddress, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func pastDueHistoryList(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.pastDueHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func PreviousDuePaymentData(SendChat:PreviousDuePayment , completion: @escaping CompletionResponse) {
        let  params : [String:String] = SendChat.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .pastDuePayment, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func chatHistoryWithDriver(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.chatHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func chatWithDriver(SendChat:chatModel , completion: @escaping CompletionResponse) {
        let  params : [String:String] = SendChat.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .chat, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func GenerateTicketService(param:GenerateTicketModel , completion: @escaping CompletionResponse) {
        let  params : [String:String] = param.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .generateTicket, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func TicketListService(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.ticketList.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
}

