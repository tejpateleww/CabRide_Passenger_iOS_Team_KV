//
//  ChangePwVC.swift
//  Peppea
//
//  Created by EWW80 on 08/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class ChangePwVC: BaseViewController
{

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtConfirmPw: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtOldPw: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtNewPw: ThemeTextFieldLoginRegister!
    var ChangePasswordModel : ChangePassword = ChangePassword()
    var loginModelDetails : LoginModel = LoginModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.backgroundColor = ThemeColor
        
        self.setNavBarWithBack(Title: "Change Password", IsNeedRightButton: false)

        txtOldPw.tag = 0
        txtNewPw.tag = 1
        txtConfirmPw.tag = 2

//        setRightViewForPassword(textField: txtOldPw)
//        setRightViewForPassword(textField: txtNewPw)
//        setRightViewForPassword(textField: txtConfirmPw)
    }
    
    @IBAction func changePasswordClick(_ sender: UIButton)
    {
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        
        do{
            loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        }
        catch
        {
            AlertMessage.showMessageForError("error")
            return
        }
        let userID = loginModelDetails.loginData.id
        
        ChangePasswordModel.new_password = txtNewPw.text ?? ""
        ChangePasswordModel.old_password = txtOldPw.text ?? ""
        
        ChangePasswordModel.customer_id = userID!
        
        if(self.ValidationForChangePwd().0 == false)
        {
            AlertMessage.showMessageForError(self.ValidationForChangePwd().1)
            //UtilityClass.showAlert(title: "", message: self.validations().1, alertTheme: .error)
        }
        else
        {
            UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
            
            UserWebserviceSubclass.changePassword(ChangePasswordModel: ChangePasswordModel) { (json, status) in
                UtilityClass.hideHUD()
                
                if status{
                    
//                    UserDefaults.standard.set(true, forKey: "isUserLogin")
//
//                    let loginModelDetails = LoginModel.init(fromJson: json)
//                    do
//                    {
//                        try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")//(loginModelDetails, forKey: "userProfile")
//                    }
//                    catch
//                    {
//                        AlertMessage.showMessageForError("error")
//                    }
                    (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                    //                    (UIApplication.shared.delegate as! AppDelegate).setHome()
                }
                else{
                    UtilityClass.hideHUD()
                    if json["message"].stringValue.count != 0 {
                        AlertMessage.showMessageForError(json["message"].stringValue)
                    }
                }
            }
        }
        
    }
    func ValidationForChangePwd() -> (Bool,String)
    {
        if(ChangePasswordModel.old_password.isBlank)
        {
            return (false,"Please enter current password")
        }
//        else if(txtOldPw.text!.count < 6)
//        {
//            return (false,"Current password length should be  minimum 6 character")
//        }
        else if(ChangePasswordModel.new_password.isBlank)
        {
            return (false,"Please enter new password")
        }
        else if(txtNewPw.text!.count < 8)
        {
            return (false,"New password length should be minimum 8 characters")
        }
        else if(txtConfirmPw.text!.isBlank)
        {
            return (false,"Please confirm the password")
        }
        else if(txtConfirmPw.text!.count < 8)
        {
            return (false,"Confirm password length should be minimum 8 characters")
        }
        else if(txtNewPw.text! != txtConfirmPw.text!)
        {
            return (false,"Confirm password must be same like new password")
        }
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

        if(sender.tag == 0)
        {
            txtOldPw.isSecureTextEntry = !sender.isSelected
        }
        else if(sender.tag == 1)
        {
            txtNewPw.isSecureTextEntry = !sender.isSelected
        }
        else if(sender.tag == 2)
        {
            txtConfirmPw.isSecureTextEntry = !sender.isSelected
        }
        //        txtPassword.isSecureTextEntry = !sender.isSelected

    }

}
