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

        let registrationContainerVC = self.navigationController?.viewControllers[1]  as! RegisterContainerViewController
        registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
        registrationContainerVC.selectPageControlIndex(Index: 2)
        self.txtOTP.text = ""

        /*
        if SingletonClass.sharedInstance.otpCode == txtOTP.text {

            let registrationContainerVC = self.navigationController?.viewControllers[1]  as! RegistrationContainerViewController
            registrationContainerVC.scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
            registrationContainerVC.selectPageControlIndex(Index: 2)
        }
        else
        {

            UtilityClass.showAlert(title: "", message: "Please enter valid OTP code", alertTheme: .error)//AlertMessage.showMessageForError("Please enter valid OTP code")
        }
        */

        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    
    

}
