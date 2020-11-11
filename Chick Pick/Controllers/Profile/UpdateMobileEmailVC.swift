//
//  UpdateMobileEmailVC.swift
//  Pappea Driver
//
//  Created by Apple on 02/10/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol updateMobileOrEmailDataSource {
    func updateData(update: String, isEmail: Bool)
}

class UpdateMobileEmailVC: BaseViewController {
    
    @IBOutlet weak var btnSubmit: UIButton!
    var delegate : updateMobileOrEmailDataSource?
    var isFromEmail = true
    var strEmailOrMobile = ""
    @IBOutlet weak var txtCountryCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtOTP: SkyFloatingLabelTextField!
    @IBOutlet weak var btnResendOTP: UIButton!
    
    var isGetOTP = false {
        didSet {
            txtOTP.isHidden = !isGetOTP
            btnResendOTP.isHidden = !isGetOTP
            txtCountryCode.isHidden = isGetOTP
            txtMobile.isHidden = isGetOTP
            txtEmail.isHidden = isGetOTP
        }
    }
    var otpNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = AppName.kAPPName
        self.setNavBarWithBack(Title: AppName.kAPPName, IsNeedRightButton: false)
        isGetOTP = false
//        btnSubmit.submitButtonLayout(isDark : true)
        
        txtCountryCode.isHidden = isFromEmail
        txtMobile.isHidden = isFromEmail
        txtEmail.isHidden = !isFromEmail
        
//        if isFromEmail {
            //            txtEmail.text = strEmailOrMobile
//            txtEmail.becomeFirstResponder()
//        }else {
            //            txtMobile.text = strEmailOrMobile
//            txtMobile.becomeFirstResponder()
//        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController?.setNavigationBarHidden(false, animated: animated)
        //        setupNavigationBarColor(navigationController)
    }
    @IBAction func submitClick(_ sender: Any) {
        if isGetOTP {
            if txtOTP.text!.isBlank {
                AlertMessage.showMessageForError("Please enter verification code")
            }else if txtOTP.text! != otpNumber {
                AlertMessage.showMessageForError("Please enter valid verification code")
            }else {
                delegate?.updateData(update: isFromEmail ? txtEmail.text! : txtMobile.text!, isEmail: isFromEmail)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            updateApi()
        }
    }
    @IBAction func resendOTP(_ sender: UIButton) {
        updateApi()
    }
    
    func updateApi() {
        var loginModelDetails: LoginModel = LoginModel()
        
        if UserDefaults.standard.object(forKey: "userProfile") != nil {
            do {
                loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
            } catch {
                AlertMessage.showMessageForError("error")
                return
            }
        }
        
        if isFromEmail {
            if txtEmail.text!.isBlank {
                AlertMessage.showMessageForError("Please enter email")
            }else if !self.isValidEmail(testStr: txtEmail.text!) {
                AlertMessage.showMessageForError("Please enter valid email")
            }else {
//                let obj = UpdateMailOrNumber()
//                let profile = loginModelDetails.responseObject
//                obj.driver_id = profile!.id
//                obj.update_type = "email"
//                obj.update_value = txtEmail.text!
//                self.updateEmailMail(obj: obj)
            }
        }else {
            if txtMobile.text!.isBlank {
                AlertMessage.showMessageForError("Please enter mobile number")
            }else if txtMobile.text!.count < 7 {
                AlertMessage.showMessageForError("Please enter valid mobile number")
            }else {
                let obj = UpdateMailOrNumber()
                let profile = loginModelDetails.loginData
                obj.customer_id = profile!.id
                obj.update_type = "mobile"
                obj.update_value = txtMobile.text!
                self.updateEmailMail(obj: obj)
            }
        }
    }
}
// MARK: - API Integration

extension UpdateMobileEmailVC {
    func updateEmailMail(obj : UpdateMailOrNumber){
        
        UserWebserviceSubclass.updateEmailOrMobile(emailNumberModel: obj) { (response, status) in
            if status {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.otpNumber = response["otp"].stringValue
                self.isGetOTP = true
            }else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}
extension UIViewController {
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
