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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func webserviceforAPPInit()
    {
        
        var strParam = String()
        
        strParam = NetworkEnvironment.baseURL + ApiKey.Init.rawValue + "/ios_customer/\(kAPPVesion)"
//
        UserWebserviceSubclass.initApi(strURL: strParam) { (json, status) in
            if status
            {
//                (UIApplication.shared.delegate as! AppDelegate).GoToLogin()
                let isLogin = UserDefaults.standard.bool(forKey: "isUserLogin")
                
                if isLogin == true
                {
                    (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                }
                else
                {
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
