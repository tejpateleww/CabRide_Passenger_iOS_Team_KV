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



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }

    func setupView()
    {
        btnForgotPassword.setTitle("Forgot Password!", for: .normal)

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

        LogInModel.Username = txtMobileEmail.text ?? ""
        LogInModel.Password = txtPassword.text ?? ""
        LogInModel.DeviceType = ""
        LogInModel.Lat = ""
        LogInModel.Lng = ""
        LogInModel.Token = ""


        if(self.validations().0 == false)
        {
            //UtilityClass.showAlert(title: "", message: self.validations().1, alertTheme: .error)

            UtilityClass.showHUD(with: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UtilityClass.hideHUD()

                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
            }

        }
        else
        {

        }


    }
    @IBAction func btnForgotPassword(_ sender: Any) {
    }

    func validations() -> (Bool,String)
    {
        if(LogInModel.Username.isBlank)
        {
            return (false,"Please enter Mobile Number/Email")
        }
        else if(LogInModel.Password.isBlank)
        {
            return (false,"Please enter Password")
        }
        else if(LogInModel.Lat.isBlank)
        {
            return (false,"Please enable your location to move forward")
        }
        else if(LogInModel.Lng.isBlank)
        {
            return (false,"Please enable your location to move forward")
        }
        else if(LogInModel.Token.isBlank)
        {
            return (false,"Please enable push notifications from Settings")
        }

        return (true,"")
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
