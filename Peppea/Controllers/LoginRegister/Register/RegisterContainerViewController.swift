//
//  RegisterContainerViewController.swift
//  Peppea
//
//  Created by Mayur iMac on 28/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class RegisterContainerViewController: UIViewController,UIScrollViewDelegate {


    @IBOutlet weak var scrollObject: UIScrollView!
    @IBOutlet weak var firstStep: UIImageView!
    @IBOutlet weak var secondStep: UIImageView!
    @IBOutlet weak var thirdStep: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()


        scrollObject.delegate = self
        self.selectPageControlIndex(Index: 0)


        

        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackAction(_ sender: Any) {
        let currentPage = self.scrollObject.contentOffset.x / self.scrollObject.frame.size.width

        if (currentPage == 0)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else if (currentPage == 1){
            self.scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.selectPageControlIndex(Index: 0)
            //            self.pageControl.set(progress: 0, animated: true)
        }
        else
        {
            self.scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.selectPageControlIndex(Index: 0)
            //            self.pageControl.set(progress: 0, animated: true)
        }
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        self.selectPageControlIndex(Index: Int(currentPage))
        //        self.pageControl.set(progress: Int(currentPage), animated: true)

    }

    func selectPageControlIndex(Index:Int) {
        self.firstStep.image = UIImage(named: "UnSelectedCircle")
        self.secondStep.image = UIImage(named: "UnSelectedCircle")
        self.thirdStep.image = UIImage(named: "UnSelectedCircle")


        self.firstStep.tintColor = ThemeColor
        self.secondStep.tintColor = ThemeColor
        self.thirdStep.tintColor = ThemeColor


        if Index == 0 {
            self.firstStep.image = UIImage(named: "SelectedCircle")
        } else if Index == 1 {
            self.secondStep.image = UIImage(named: "SelectedCircle")
            for  ChildViewController in self.children {
                if let Childpage = ChildViewController as? RegisterOTPVarificationViewController {
                    Childpage.txtOTP.text = ""
                }
            }
        } else if Index == 2 {
            self.thirdStep.image = UIImage(named: "SelectedCircle")
        }

        self.firstStep.tintColor = .black
        self.secondStep.tintColor = .black
        self.thirdStep.tintColor = .black
    }

    
    // MARK: - WebserviceCall
    
    func webServiceCallForRegister(_ RegistrationGetOTPModel : RegistrationModel, image : UIImage)
    {
        
        /*
         "email:dev.elop.er.eww@gmail.com
         mobile_no:9924455777
         first_name:Mayur
         last_name:Patel
         dob:1992-07-07
         gender:male
         lat:23.8656565
         lng:72.654656
         device_token:sadfdfs65c4dwfvwdv6edbv16efbef1b165165
         device_type:1
         address:Nikol bapunagar
         password:123456
         profile_image:(optional)"
         */
        
//        RegistrationGetOTPModel.email = SingletonRegistration.sharedRegistration.Email
//        RegistrationGetOTPModel.mobile_no = SingletonRegistration.sharedRegistration.MobileNo
//        RegistrationGetOTPModel.password = SingletonRegistration.sharedRegistration.Password
//        RegistrationGetOTPModel.first_name = txtFirstName.text ?? ""
//        RegistrationGetOTPModel.last_name = txtLastName.text ?? ""
//        RegistrationGetOTPModel.RefarralCode = txtRafarralCode.text ?? ""
//        RegistrationGetOTPModel.dob = txtDateOfBirth.text ?? ""
//        RegistrationGetOTPModel.gender = gender
//        RegistrationGetOTPModel.device_type = "ios"
//        RegistrationGetOTPModel.lat = "23.75821"
//        RegistrationGetOTPModel.lng = "23.75821"
//        RegistrationGetOTPModel.device_token = "64546546464646465465464"
//        RegistrationGetOTPModel.address = "Ahmedabad"
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        
        UserWebserviceSubclass.register(registerModel: RegistrationGetOTPModel, image: image, imageParamName: "profile_image", completion: { (json, status) in
            UtilityClass.hideHUD()
            
            if status{
                
                UserDefaults.standard.set(true, forKey: "isUserLogin")
                
                let registerModelDetails = LoginModel.init(fromJson: json)
                do
                {
                    SingletonClass.sharedInstance.walletBalance = registerModelDetails.loginData.walletBalance
                    try UserDefaults.standard.set(object: registerModelDetails, forKey: "userProfile")//(loginModelDetails, forKey: "userProfile")
                }
                catch
                {
                    AlertMessage.showMessageForError("error")
                }
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
            }
            else{
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        })
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
