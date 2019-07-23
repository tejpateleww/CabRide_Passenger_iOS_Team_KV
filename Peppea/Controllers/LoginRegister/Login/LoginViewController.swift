//
//  LoginViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var txtMobileEmail: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtPassword: ThemeTextFieldLoginRegister!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignIn: ThemeButton!
    @IBOutlet weak var loginWithFacebook: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblDontHaveAnAccount: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    var LogInModel : loginModel = loginModel()



    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtMobileEmail.text = "dev.eloper.eww@gmail.com"
        txtPassword.text = "12345678"
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
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "navigateToRegister", sender: nil)
    }

    @IBAction func btnSIgnIn(_ sender: ThemeButton) {

        LogInModel.username = txtMobileEmail.text ?? ""
        LogInModel.password = txtPassword.text ?? ""
        LogInModel.device_type = "ios"
        LogInModel.lat = "23.75821"
        LogInModel.lng = "23.75821"
        LogInModel.device_token = "64546546464646465465464"
        if(self.validations().0 == false)
        {
             AlertMessage.showMessageForError(self.validations().1)
        }
        else
        {
            self.webserviceCallForLogin()
        }


    }
    
    func webserviceCallForLogin()
    {
        UtilityClass.showHUD(with: self.view)
        
        UserWebserviceSubclass.login(loginModel: LogInModel) { (json, status) in
            UtilityClass.hideHUD()
            
            if status{
                
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                let loginModelDetails = LoginModel.init(fromJson: json)
                do
                {
                    UserDefaults.standard.set(loginModelDetails.loginData.xApiKey, forKey: "X_API_KEY")
                    SingletonClass.sharedInstance.walletBalance = loginModelDetails.loginData.walletBalance
                    try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")//(loginModelDetails, forKey: "userProfile")
                }
                catch
                {
                    UtilityClass.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                //                    (UIApplication.shared.delegate as! AppDelegate).setHome()
            }
            else{
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
        
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //                UtilityClass.hideHUD()
        //
        //                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
        //            }
    }
    @IBAction func btnForgotPassword(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
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
        else if(LogInModel.device_token.isBlank)
        {
            return (false,"Please enable push notifications from Settings")
        }

        return (true,"")
    }


 
}
