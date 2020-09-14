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
    
    var RegistrationGetOTPModel : RegistrationModel = RegistrationModel()
    
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
            //            let registrationContainerVC = self.navigationController?.viewControllers[1]  as! RegisterContainerViewController
            //            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
            //            registrationContainerVC.selectPageControlIndex(Index: 2)
            self.txtOTP.text = ""
            SingletonClass.sharedInstance.RegisterOTP = ""
            webServiceCallForRegister()
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
                UtilityClass.hideHUD()
                if json["message"].stringValue.count != 0 {
                    AlertMessage.showMessageForError(json["message"].stringValue)
                }
            }
            //            completion(status)
        }
    }
    
    func webServiceCallForRegister()
    {
        let myLocation = SingletonClass.sharedInstance.myCurrentLocation
        RegistrationGetOTPModel.email = SingletonRegistration.sharedRegistration.Email
        RegistrationGetOTPModel.mobile_no = SingletonRegistration.sharedRegistration.MobileNo
        RegistrationGetOTPModel.password = SingletonRegistration.sharedRegistration.Password
        RegistrationGetOTPModel.first_name = SingletonRegistration.sharedRegistration.FirstName
        RegistrationGetOTPModel.last_name = SingletonRegistration.sharedRegistration.LastName
        RegistrationGetOTPModel.device_type = "ios"
        RegistrationGetOTPModel.lat = "\(myLocation.coordinate.latitude)" //"23.75821"
        RegistrationGetOTPModel.lng = "\(myLocation.coordinate.longitude)" //"23.75821"
        
        if let parentVC = self.parent as? RegisterContainerViewController {
            if let data = parentVC.userSocialData {
                self.RegistrationGetOTPModel.social_id = data.userId
                self.RegistrationGetOTPModel.social_type = data.socialType
            }
        }
        
        //        RegistrationGetOTPModel.RefarralCode = txtRafarralCode.text ?? ""
               //        RegistrationGetOTPModel.dob = txtDateOfBirth.text ?? ""
               //        RegistrationGetOTPModel.gender = gender
        //        RegistrationGetOTPModel.user_type = self.getSelectedType()
        //        RegistrationGetOTPModel.company_name = (RegistrationGetOTPModel.user_type == "company") ? self.txtSelectCompany.text! : ""
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            RegistrationGetOTPModel.device_token = token
        }
        //        RegistrationGetOTPModel.address = txtAddress.text ?? ""
        
        if let vc = self.parent as? RegisterContainerViewController
        {
            vc.webServiceCallForRegister(RegistrationGetOTPModel, image: SingletonRegistration.sharedRegistration.Document)
        }
    }
}
