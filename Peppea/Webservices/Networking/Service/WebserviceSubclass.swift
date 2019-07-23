//
//  UserWebserviceSubclass.swift
//  Pappea Driver
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
    class func register( registerModel : RegistrationModel , image: UIImage, imageParamName: String ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
        WebService.shared.postDataWithImage(api: .register, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
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
    
    class func updatePersonal(updateProfile : UpdatePersonalInfo, image: UIImage, imageParamName: String, completion: @escaping CompletionResponse)
    {
        let params : [String: String] = updateProfile.generatPostParams() as! [String:String]
        WebService.shared.postDataWithImage(api: .profileUpdate, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
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
    class func Logout( strURL : String  ,completion: @escaping CompletionResponse )
    {
        let strURLFinal = NetworkEnvironment.baseURL + ApiKey.logout.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
}
