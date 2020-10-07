//
//  LoginViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FBSDKLoginKit

struct UserSocialData {
    var userId: String
    var firstName: String
    var lastName: String
    var userEmail: String
    var socialType: String
    var Profile : String
}

class LoginViewController: UIViewController {

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
    @IBOutlet weak var lblNewUser: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    
    var LogInModel : loginModel = loginModel()
    var userSocialData: UserSocialData?

    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
            txtMobileEmail.text = "bhumi.jani123@gmail.com"
            txtPassword.text = "12345678"
        #else
        
        if UIDevice.current.name == "iPad red" || UIDevice.current.name == "EWW iPhone 7 Plus" {
            txtMobileEmail.text = "bhumi.jani123@gmail.com"
            txtPassword.text = "12345678"
        }
        
        #endif
        /*
        Peppea Passenger
         
        As a company register
        "email" : "test101@gmail.com",
        "mobile_no" : "9955114477"
        Password : 12345678
        
        Register under company
        "email" : "test101@gmail.com"
        "mobile_no" : "9955114477"
        Password : 12345678
        */

        
        /*Employees login Cred : Email = emp@yahoo.com || Pw = 12345678 */
        
    
//        setRightViewForPassword(textField: txtPassword)
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }

    func setupView()
    {
        btnForgotPassword.setTitle("Forgot Password?", for: .normal)

        btnSignUp.setTitleColor(ThemeOrange, for: .normal)
        btnSignUp.titleLabel?.font = UIFont.semiBold(ofSize: 15)

        btnForgotPassword.titleLabel?.font = UIFont.regular(ofSize: 13)
        btnSignIn.titleLabel?.font = UIFont.semiBold(ofSize: 17)

        lblDontHaveAnAccount.font = UIFont.regular(ofSize: 15)
        lblNewUser.font = UIFont.regular(ofSize: 15)

        lblDontHaveAnAccount.textColor = ThemeColor
        lblNewUser.textColor = ThemeColor
        
    }
    
    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "navigateToRegister", sender: nil)
    }

    @IBAction func btnSIgnIn(_ sender: ThemeButton) {
        
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

    @IBAction func btnFBTapped(_ sender: Any) {
        
        if !WebService.shared.isConnected {
            AlertMessage.showMessageForError("Please check your internet")
            return
        }
        let login = LoginManager()
        login.logOut()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if error != nil {
                //                UIApplication.shared.statusBarStyle = .lightContent
            }
            else if (result?.isCancelled)! {
                //                UIApplication.shared.statusBarStyle = .lightContent
            }else {
                if (result?.grantedPermissions.contains("email"))! {
                    //                    UIApplication.shared.statusBarStyle = .lightContent
                    self.getFBUserData()
                }else {
                    print("you don't have permission")
                }
            }
        }
    }
    
    func getFBUserData() {
        
        var parameters = [AnyHashable: Any]()
        parameters["fields"] = "first_name, last_name, email, id, picture.type(large)"
        
        GraphRequest.init(graphPath: "me", parameters: parameters as! [String : Any]).start { (connection, result, error) in
            if error == nil {
                
                print("\(#function) \(result!)")
                let dictData = result as! [String : AnyObject]
                let strFirstName = String(describing: dictData["first_name"]!)
                let strLastName = String(describing: dictData["last_name"]!)
                let strEmail = String(describing: dictData["email"]!)
                let strUserId = String(describing: dictData["id"]!)
                
                let profile = ((dictData["picture"] as! [String:AnyObject])["data"]  as! [String:AnyObject])["url"] as! String
                print(profile)
                
                self.userSocialData = UserSocialData(userId: strUserId, firstName: strFirstName, lastName: strLastName, userEmail: strEmail, socialType: "facebook", Profile: profile)
                
                let socialModel = SocialLoginModel()
                socialModel.social_id = strUserId
                socialModel.first_name = strFirstName
                socialModel.last_name = strLastName
                socialModel.email = strEmail
                socialModel.social_type = "facebook"
                socialModel.device_type = "ios"
                if let token = UserDefaults.standard.object(forKey: "Token") as? String
                {
                    socialModel.device_token = token
                }
               
               let myLocation = SingletonClass.sharedInstance.myCurrentLocation
    
                socialModel.lat = "\(myLocation.coordinate.latitude)" // "23.75821"
                socialModel.lng = "\(myLocation.coordinate.longitude)" // "72.75821"
                
                #if targetEnvironment(simulator)
                // 23.0732727,72.5181843
                socialModel.lat = "23.0732727"
                socialModel.lng = "72.5181843"
                #endif
                
                self.webserviceCallForSocialLogin(socialModel: socialModel)
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    
    func webserviceCallForSocialLogin(socialModel : SocialLoginModel) {
        
          UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
           UserWebserviceSubclass.socialModel(socialModel: socialModel) { (json, status) in
               
            UtilityClass.hideHUD()
            
            if status{
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                let loginModelDetails = LoginModel.init(fromJson: json)
                let Vehiclelist = VehicleListModel(fromJson: json)
                do
                {
                    UserDefaults.standard.set(loginModelDetails.loginData.xApiKey, forKey: "X_API_KEY")
                    SingletonClass.sharedInstance.walletBalance = loginModelDetails.loginData.walletBalance
                    SingletonClass.sharedInstance.BulkMilesBalance = loginModelDetails.loginData.BulkMilesBalance
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile") //(loginModelDetails, forKey: "userProfile")
                    SingletonClass.sharedInstance.loginData = loginModelDetails.loginData
                    try UserDefaults.standard.set(object: Vehiclelist, forKey: "carList")
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
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterContainerViewController") as! RegisterContainerViewController
                viewController.userSocialData = self.userSocialData
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    func webserviceCallForLogin()
    {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.login(loginModel: LogInModel) { (json, status) in
            UtilityClass.hideHUD()
            
            print(json)
            
            if status{
                
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                let loginModelDetails = LoginModel.init(fromJson: json)
                let Vehiclelist = VehicleListModel(fromJson: json)
                do
                {
                    UserDefaults.standard.set(loginModelDetails.loginData.xApiKey, forKey: "X_API_KEY")
                    SingletonClass.sharedInstance.walletBalance = loginModelDetails.loginData.walletBalance
                    SingletonClass.sharedInstance.BulkMilesBalance = loginModelDetails.loginData.BulkMilesBalance
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile") //(loginModelDetails, forKey: "userProfile")
                    SingletonClass.sharedInstance.loginData = loginModelDetails.loginData
                    try UserDefaults.standard.set(object: Vehiclelist, forKey: "carList")
                    if json.dictionary?["booking_info"] != nil {
                        let info = BookingInfo(fromJson: json.dictionary?["booking_info"])
                        SingletonClass.sharedInstance.bookingInfo = info
                    }
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error, try again")
                }

//                (UIApplication.shared.delegate as! AppDelegate).GoToHome() // Commented by Rahul for Choose services Option i.e. Hire a Car or Book a taxi option
                self.redirectToChooseServicesVC()

             }
            else{
                UtilityClass.hideHUD()
                if json["message"].stringValue.count != 0 {
                    AlertMessage.showMessageForError(json["message"].stringValue)
                }
            }
        }
    }

    func redirectToChooseServicesVC()
    {
        if let dictValue = UserDefaults.standard.object(forKey: "didSelectTaxiStatus") as? [String:Bool]
        {
            if(dictValue["isDefaultScreen"]!)
            {
                //redirect to choose service VC
//                (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()

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
//             (UIApplication.shared.delegate as! AppDelegate).GoToChooseServices()
            (UIApplication.shared.delegate as! AppDelegate).GoToHome()

        }

    }
   
    func validations() -> (Bool,String)
    {

        if(LogInModel.username.isBlank)
        {
            return (false,"Please enter mobile number/email")
        }
        else if(LogInModel.password.isBlank)
        {
            return (false,"Please enter password")
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
