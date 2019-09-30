//
//  LoginViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RentalLoginViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------

    @IBOutlet weak var txtMobileEmail: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtPassword: ThemeTextFieldLoginRegister!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignIn: ThemeButton!
    @IBOutlet weak var loginWithFacebook: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblDontHaveAnAccount: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    var LogInModel : loginModel = loginModel()

    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
            txtMobileEmail.text = "bhavesh@gmail.com"
            txtPassword.text = "12345678"
        #else
        
        if UIDevice.current.name == "iPad red" || UIDevice.current.name == "EWW iPhone 7 Plus" {
            txtMobileEmail.text = "bhavesh@gmail.com"
            txtPassword.text = "12345678"
        }
        
        #endif

        setRightViewForPassword(textField: txtPassword)
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }

    func setupView()
    {
        btnForgotPassword.setTitle("Forgot Password?", for: .normal)

        UtilityClass.viewCornerRadius(view: btnSignUp, borderWidth: 1.0, borderColor: ThemeColor)

        btnSignUp.setTitleColor(ThemeColor, for: .normal)

        btnForgotPassword.titleLabel?.font = UIFont.regular(ofSize: 13)
        btnSignIn.titleLabel?.font = UIFont.semiBold(ofSize: 17)

        lblOr.font = UIFont.regular(ofSize: 14)
        lblDontHaveAnAccount.font = UIFont.regular(ofSize: 15)

        lblOr.textColor = ThemeColor
        lblDontHaveAnAccount.textColor = ThemeColor
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "navigateToRegister", sender: nil)
    }

    @IBAction func btnSIgnIn(_ sender: ThemeButton) {
        
        appDelegate.goToRentalHome()

        UserDefaults.standard.set(true, forKey: "isUserLogin")

        return
        
        ///--- RETURN ---
        
        let myLocation = SingletonClass.sharedInstance.myCurrentLocation
        
        LogInModel.username = txtMobileEmail.text ?? ""
        LogInModel.password = txtPassword.text ?? ""
        LogInModel.device_type = "ios"
        LogInModel.lat = "\(myLocation.coordinate.latitude)" // "23.75821"
        LogInModel.lng = "\(myLocation.coordinate.longitude)" // "72.75821"
        LogInModel.device_token = "sdfsdfwrfw4rt34r53"
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            LogInModel.device_token = token
        }
        
        if(self.validations().0 == false)  {
            AlertMessage.showMessageForError(self.validations().1)
        }
        else {
            self.webserviceCallForLogin()
        }

    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------

    func webserviceCallForLogin()
    {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.login(loginModel: LogInModel) { (json, status) in
            UtilityClass.hideHUD()
            
            print(json)
            
            if status{
                
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                //json is a Swifty Json format
                //Converting from Swifty Json format to Login Model (Codable foramt) using key value pair
                //Storing to user defaults custom object as it is Codable
                let loginModelDetails = LoginModel.init(fromJson: json)
                do
                {
                    UserDefaults.standard.set(loginModelDetails.loginData.xApiKey, forKey: "X_API_KEY")
                    SingletonClass.sharedInstance.walletBalance = loginModelDetails.loginData.walletBalance
                    SingletonClass.sharedInstance.BulkMilesBalance = loginModelDetails.loginData.BulkMilesBalance
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile") //(loginModelDetails, forKey: "userProfile")
                    SingletonClass.sharedInstance.loginData = loginModelDetails.loginData
                    
                    if json.dictionary?["booking_info"] != nil {
                        let info = BookingInfo(fromJson: json.dictionary?["booking_info"])
                        SingletonClass.sharedInstance.bookingInfo = info
                    }
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error")
                }

//                (UIApplication.shared.delegate as! AppDelegate).GoToHome() // Commented by Rahul for Choose services Option i.e. Hire a Car or Book a taxi option
                self.redirectToChooseServicesVC()

             }
            else{
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    
    func webServiceForLogin1() {
    
        let myLocation = SingletonClass.sharedInstance.myCurrentLocation
        
        LogInModel.username = txtMobileEmail.text ?? ""
        LogInModel.password = txtPassword.text ?? ""
        LogInModel.device_type = "ios"
        LogInModel.lat = "\(myLocation.coordinate.latitude)" // "23.75821"
        LogInModel.lng = "\(myLocation.coordinate.longitude)" // "72.75821"
        LogInModel.device_token = "sdfsdfwrfw4rt34r53"
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            LogInModel.device_token = token
        }
        
        UserWebserviceSubclass.login(loginModel: LogInModel) { jsonRes, isSuccess in
            
            
            
            
            
            
            
            }
        
        
    }

    func redirectToChooseServicesVC()
    {
        if let dictValue = UserDefaults.standard.object(forKey: "didSelectTaxiStatus") as? [String:Bool]
        {
            if(dictValue["isDefaultScreen"]!)
            {
                //redirect to choose service VC
                (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()
            }
            else
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
        }
        else
        {
             (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()
        }

    }
   
    func validations() -> (Bool,String)
    {

        if(LogInModel.username.isBlank)
        {
            return (false,"Please enter Mobile Number/Email")
        }
        else if(LogInModel.password.isBlank)
        {
            return (false,"Please enter Password")
        }
        else if(LogInModel.lat.isBlank)
        {
            return (false,"Please enable your location to move forward")
        }
        else if(LogInModel.lng.isBlank)
        {
            return (false,"Please enable your location to move forward")
        }
//        else if(LogInModel.device_token.isBlank)
//        {
//            return (false,"Please enable push notifications from Settings")
//        }

        return (true,"")
    }

    func setRightViewForPassword(textField: UITextField)
    {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconHidePassword"), for: .normal)
        button.setImage(UIImage(named: "iconShowPassword"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.tag = textField.tag
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.showHidePassword), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always

    }

    @objc func showHidePassword(sender : UIButton)
    {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = !sender.isSelected
    }
 
}
