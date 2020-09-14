//
//  ForgotPasswordViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 03/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController
{
    @IBOutlet weak var lblForgetPW: UILabel!
    
    @IBOutlet weak var txtEmail: ThemeTextFieldLoginRegister!
    @IBOutlet weak var btnResetPw: UIButton!
    
      var ForgotPasswordModel : ForgotPassword = ForgotPassword()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Forgot Password", IsNeedRightButton: false)
    }
    
    func uiSettings()
    {
        btnResetPw.backgroundColor = ThemeColor
        lblForgetPW.font = UIFont.semiBold(ofSize: 20)
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnREsetPAsswordClicked(_ sender: Any)
    {
//        self.navigationController?.popViewController(animated: true)
        ForgotPasswordModel.email = txtEmail.text ?? ""
        
        if(self.validations().0 == false)
        {
            AlertMessage.showMessageForError(self.validations().1)
        }
        else
        {
            self.webserviceCallForgotPassword()
        }

    }
    func webserviceCallForgotPassword()
    {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.forgotPassword(ForgotPasswordModel: ForgotPasswordModel) { (json, status) in
            UtilityClass.hideHUD()
            
            if status{
                 AlertMessage.showMessageForSuccess(json["message"].stringValue)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                UtilityClass.hideHUD()
                if json["message"].stringValue.count != 0 {
                    AlertMessage.showMessageForError(json["message"].stringValue)
                }
            }
        }
    }
    func validations() -> (Bool,String)
    {
        
        if(ForgotPasswordModel.email.isBlank)
        {
            return (false,"Please enter email")
        }
        else if(!ForgotPasswordModel.email.isEmail)
        {
            return (false,"Please enter a valid email")
        }
       
        return (true,"")
    }
}
