//
//  RegisterOTPVarificationViewController.swift
//  PickNGo User
//
//  Created by Excelent iMac on 17/02/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterOTPVarificationViewController: UIViewController {


    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var txtOTP: ThemeTextFieldLoginRegister!

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnResetOtp(_ sender: Any) {
        webserviceForResendOTP()
    }
    func setCornerToTextField(txtField : UITextField)
    {
        txtField.layer.cornerRadius = txtField.frame.height / 2
        txtField.layer.borderColor = UIColor.white.cgColor
        txtField.layer.borderWidth = 1.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnNext(_ sender: UIButton) {

        let strOTP = txtOTP.text
        
        if strOTP == SingletonClass.sharedInstance.RegisterOTP
        {
            let registrationContainerVC = self.navigationController?.viewControllers[1]  as! RegisterContainerViewController
            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
            registrationContainerVC.selectPageControlIndex(Index: 2)
            self.txtOTP.text = ""
            SingletonClass.sharedInstance.RegisterOTP = ""
        }
        else
        {
//            UtilityClass.showAlert(title: "", message: "Please enter valid OTP code", alertTheme: .error)//AlertMessage.showMessageForError("Please enter valid OTP code")
            AlertMessage.showMessageForError("Please enter valid OTP code")
        }
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceForResendOTP()
    {
        var paramter = [String : AnyObject]()
        paramter["email"] = SingletonRegistration.sharedRegistration.Email as AnyObject
        paramter["mobile_no"] = SingletonRegistration.sharedRegistration.MobileNo as AnyObject


        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)

        WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: paramter){ json,status in
            UtilityClass.hideHUD()
            if status
            {
                //                self.parameterArray.otp = json["otp"].stringValue
                AlertMessage.showMessageForSuccess(json["message"].stringValue)
                SingletonClass.sharedInstance.RegisterOTP = json["otp"].stringValue
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
            //            completion(status)
        }
    }
    

}
