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

        
        self.determiningTheAppName()
        
        //Peppea or Peppea Rental
        
        if AppName.getkAppName() == .peppea {

            self.webserviceforAPPInit()
        
        }else{
            //Peppea Rental
            self.redirectToPeppeaRentalFlow()
            
        }
        

        // Do any additional setup after loading the view.
    }

    func determiningTheAppName(){
        
        if self.view.tag == 1 {

            //Peppea Rental App
            AppName.set(appName: .peppeaRental)

        }else{
            //Peppea App
            AppName.set(appName: .peppea)

        }
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

                if let walletBalance = loginModelDetails.loginData.walletBalance
                {
                    SingletonClass.sharedInstance.BulkMilesBalance = walletBalance
                }

                if let bulkMileBalance = loginModelDetails.loginData.BulkMilesBalance
                {
                    SingletonClass.sharedInstance.BulkMilesBalance = bulkMileBalance
                }
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
//                        (UIApplication.shared.delegate as! AppDelegate).GoToHome(bookingInfo: info) // Commented by Rahul for Choose services Option i.e. Hire a Car or Book a taxi option
                    } else {
//                        (UIApplication.shared.delegate as! AppDelegate).GoToHome() // Commented by Rahul for Choose services Option i.e. Hire a Car or Book a taxi option
                    }

                    self.redirectToChooseServicesVC()
                }
                else {
                    (UIApplication.shared.delegate as! AppDelegate).GoToLogin()
                }
            }
            else
            {
                
            }
        }

    }



    func redirectToChooseServicesVC()
    {
        if let dictValue = UserDefaults.standard.object(forKey: "didSelectTaxiStatus") as? [String:Bool]
        {
            if(dictValue["isDefaultScreen"]!)
            {

                if(dictValue["didSelectTaxi"]!)
                {
                    (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                    //redirect to Main storyboard home
                }
                else
                {

                    //redirect to hire a car in future
                    (UIApplication.shared.delegate as! AppDelegate).GoToHome()

                }
            }
            else
            {

                (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()

            }
        }
        else if(UserDefaults.standard.bool(forKey: "isUserLogin") == false)
        {
            (UIApplication.shared.delegate as! AppDelegate).GoToLogin()
        }
        else
        {
            (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()

        }

    }

}


extension SplashViewController {
    
    
    func redirectToPeppeaRentalFlow() {
        
//        if(UserDefaults.standard.bool(forKey: "isUserLogin") == false)
//        {
            (UIApplication.shared.delegate as! AppDelegate).goToPeppeaRentalLogin()
//        }
//        else
//        {
//            (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()
//
//        }
        
        
        
        
    }
}
