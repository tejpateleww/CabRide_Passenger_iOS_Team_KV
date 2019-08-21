//
//  SplashViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var animateView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webserviceforAPPInit()
        
//        (UIApplication.shared.delegate as! AppDelegate).GoToHome()


        // Do any additional setup after loading the view.
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func webserviceforAPPInit()
    {
        
        var loginModelDetails = LoginModel()
        do
        {
            if UserDefaults.standard.object(forKey: "userProfile") != nil {
                
                loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")! // set(object: loginModelDetails, forKey: "userProfile") //(loginModelDetails, forKey: "userProfile")
                UserDefaults.standard.set(loginModelDetails.loginData.xApiKey, forKey: "X_API_KEY")
                SingletonClass.sharedInstance.loginData = loginModelDetails.loginData
                SingletonClass.sharedInstance.walletBalance = loginModelDetails.loginData.walletBalance
                SingletonClass.sharedInstance.BulkMilesBalance  = loginModelDetails.loginData.BulkMilesBalance
                
            }
        }
        catch
        {
            UtilityClass.hideHUD()
            AlertMessage.showMessageForError("error")
        }
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + "ios_customer/\(kAPPVesion)"
        if SingletonClass.sharedInstance.loginData.id != nil || SingletonClass.sharedInstance.loginData.id != "" {
            
            strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + "ios_customer/\(kAPPVesion)/\(SingletonClass.sharedInstance.loginData.id ?? "")"
        }
        
//
        UserWebserviceSubclass.initApi(strURL: strParam) { (json, status) in
            if status
            {
                //                (UIApplication.shared.delegate as! AppDelegate).GoToLogin()
                
                let VehicleListModelDetails = VehicleListModel.init(fromJson: json)
                do
                {
                    try UserDefaults.standard.set(object: VehicleListModelDetails, forKey: "carList")//(loginModelDetails, forKey: "userProfile")
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
                
                let isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
                
                if isLogin == true || (SingletonClass.sharedInstance.loginData.id != "" && SingletonClass.sharedInstance.loginData.id != nil) {
                    
                    if json.dictionary?["booking_info"] != nil {
                        let info = BookingInfo(fromJson: json.dictionary?["booking_info"])
                        SingletonClass.sharedInstance.bookingInfo = info
                        (UIApplication.shared.delegate as! AppDelegate).GoToHome(bookingInfo: info)
                    } else {
                        (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                    }
                }
                else {
                    (UIApplication.shared.delegate as! AppDelegate).GoToLogin()
                }
            }
            else
            {
                
            }
        }
//        webserviceForAPPVerison(strParam as AnyObject, showHUD: false) { (result, status) in
//            if status
//            {
//                guard let strMSG = result["message"] as? String else
//                {
//                    self.perform(#selector(self.moveToLogin), with: nil, afterDelay: 5.0)
//                    return
//                }
//                if let strUpdate = result["update"] as? Bool
//                {
//                    RMUniversalAlert.show(in: self, withTitle:appName, message: strMSG, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Update", "Later"], tap: {(alert, buttonIndex) in
//                        if (buttonIndex == 2)
//                        {
//                            if let url = URL(string: "https://itunes.apple.com/us/app/tesluxe/id1438245899?ls=1&mt=8"),
//                                UIApplication.shared.canOpenURL(url)
//                            {
//                                if #available(iOS 10.0, *)
//                                {
//                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                                }
//                                else
//                                {
//                                    UIApplication.shared.openURL(url)
//                                }
//                            }
//                        }
//                        else
//                        {
//                            self.perform(#selector(self.moveToLogin), with: nil, afterDelay: 0.0)
//                        }
//                    })
//                }
//            }
//            else
//            {
//
//
//
//
//                //                    if let result as? String// == "The request timed out."
//                //                    {
//                //                        self.perform(#selector(self.moveToLogin), with: nil, afterDelay: 0.0)
//                //                    }
//                //                        else if result as! String == "The Internet connection appears to be offline."
//                //                    {
//                //                        Utilities.showAlert(appName, message: "The Internet connection appears to be offline.", vc: self)
//                //                    }
//                //                    else
//                //                    {
//                //                        self.perform(#selector(self.moveToLogin), with: nil, afterDelay: 0.0)
//
//                //                    }
//                //                    if Utilities.isInternetConnectionAvailable()
//                //                    {
//
//                //                    }
//                //                    else
//                //                    {
//                //                        Utilities.showToastMSG(MSG: message_NoInternetConnection)
//                //                    }
//            }
//        }
    }

}
