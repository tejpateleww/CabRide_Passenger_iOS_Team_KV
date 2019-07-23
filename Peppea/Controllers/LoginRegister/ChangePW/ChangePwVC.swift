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
                    
                    UserDefaults.standard.set(true, forKey: "isUserLogin")
                    
                    let loginModelDetails = LoginModel.init(fromJson: json)
                    do
                    {
                        try UserDefaults.standard.set(object: loginModelDetails, forKey: "userProfile")//(loginModelDetails, forKey: "userProfile")
                    }
                    catch
                    {
                        AlertMessage.showMessageForError("error")
                    }
                    (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                    //                    (UIApplication.shared.delegate as! AppDelegate).setHome()
                }
                else{
                    AlertMessage.showMessageForError(json["message"].stringValue)
                }
            }
        }
        
    }
    func ValidationForChangePwd() -> (Bool,String)
    {
        if(ChangePasswordModel.old_password.isBlank)
        {
            return (false,"Please enter old password")
        }
        else if(txtOldPw.text!.count < 6)
        {
            return (false,"Old Password length should be  minimum 6 character")
        }
        else if(ChangePasswordModel.new_password.isBlank)
        {
            return (false,"Please enter new password")
        }
        else if(txtNewPw.text!.count < 6)
        {
            return (false,"New Password length should be  minimum 6 character")
        }
        else if(txtConfirmPw.text!.isBlank)
        {
            return (false,"Please enter confirm password")
        }
        else if(txtConfirmPw.text!.count < 6)
        {
            return (false,"Confirm Password length should be  minimum 6 character")
        }
        else if(txtNewPw.text! != txtConfirmPw.text!)
        {
            return (false,"Confirm Password must be same like new password")
        }
         return (true,"")
    }
    
    
   

}
