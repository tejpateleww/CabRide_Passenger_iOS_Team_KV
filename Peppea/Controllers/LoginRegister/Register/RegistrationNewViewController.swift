//
//  RegistrationNewViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MobileCoreServices

//import TransitionButton

class RegistrationNewViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var strDateOfBirth = String()

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var txtFirstName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtLastName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtDateOfBirth: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtRafarralCode: ThemeTextFieldLoginRegister!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!

    @IBOutlet var selectGender: [UIImageView]!


    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    var strPhoneNumber = String()
    var strEmail = String()
    var strPassword = String()
    var gender = String()
    var isImageSelected:Bool = false
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------

    var didSelectMale: Bool = true
    {
        didSet
        {
            if(didSelectMale)
            {
                selectGender.first?.image = UIImage(named: "SelectedCircle")
                selectGender.last?.image = UIImage(named: "UnSelectedCircle")


            }
            else
            {
                selectGender.last?.image = UIImage(named: "SelectedCircle")
                selectGender.first?.image = UIImage(named: "UnSelectedCircle")

            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        selectGender.first?.tintColor = ThemeColor
        selectGender.last?.tintColor = ThemeColor

    }



    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnProfileImage.layer.cornerRadius = self.btnProfileImage.frame.size.width/2
        self.btnProfileImage.layer.masksToBounds = true
        self.btnProfileImage.contentMode = .scaleAspectFill

        /*
         if SingletonClass.sharedInstance.strSocialImage != "" {

         let url = URL(string: SingletonClass.sharedInstance.strSocialImage)
         let data = try? Data(contentsOf: url!)

         if let imageData = data {
         self.imgProfile.image = UIImage(data: imageData)!
         }else {
         self.imgProfile.image = UIImage(named: "iconUser")!
         }

         }
         */
    }

    @IBAction func btnSelectGender(_ sender: UIButton) {

        if(sender.tag == 1) // Male
        {
            didSelectMale = true
        }
        else if (sender.tag == 2) // Female
        {
            didSelectMale = false
        }

    }

    // MARK: - Pick Image
    func TapToProfilePicture() {



        
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        // picker.stopVideoCapture()
        picker.mediaTypes = [kUTTypeImage as String]
        //UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        setNavigationFontBlack()
        present(picker, animated: true, completion: nil)
    }
    
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        setNavigationFontBlack()
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Image Delegate and DataSource Methods


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.isImageSelected = true
            btnProfileImage.imageView?.contentMode = .scaleToFill
            btnProfileImage.setImage(pickedImage, for: .normal)
        }
        setNavigationClear()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        setNavigationClear()

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func txtDateOfBirth(_ sender: SkyFloatingLabelTextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.pickupdateMethod(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func pickupdateMethod(_ sender: UIDatePicker)
    {
        let dateFormaterView = DateFormatter()
        dateFormaterView.dateFormat = "yyyy-MM-dd"
        txtDateOfBirth.text = dateFormaterView.string(from: sender.date)
        strDateOfBirth = txtDateOfBirth.text!
        
    }

    

    
    //MARK: - Validation
    
    func isValidateValue() -> (Bool,String) {
        var isValid:Bool = true
        var ValidatorMessage:String = ""
        
        if self.txtFirstName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {

            isValid = false
            ValidatorMessage = "Please enter first name."

        } else if self.txtLastName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            
            isValid = false
            ValidatorMessage = "Please enter last name."

        } else if self.strDateOfBirth == "" {
            
            isValid = false
            ValidatorMessage = "Please choose date of birth."

        } else if gender == "" {
            
            isValid = false
            ValidatorMessage = "Please choose gender."

        }
        return (isValid,ValidatorMessage)
    }

    //MARK: - IBActions
    
    @IBAction func btnChooseImage(_ sender: Any) {
        
        self.TapToProfilePicture()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        let Validator = self.isValidateValue()
        
        if Validator.0 == true
        {
            let registerVC = (self.navigationController?.viewControllers.last as! RegisterContainerViewController).children[0] as! RegisterViewController
            
            strPhoneNumber = (registerVC.txtPhoneNumber.text)!
            strEmail = (registerVC.txtEmail.text)!
            strPassword = (registerVC.txtPassword.text)!

            //            webServiceCallForRegister()
        } else {
            UtilityClass.showAlert(title: "", message: Validator.1, alertTheme: .error)
        }
    }


    /*

     // MARK: - WebserviceCall

     func webServiceCallForRegister()
     {

     let dictParams = NSMutableDictionary()
     dictParams.setObject(txtFirstName.text!, forKey: "Firstname" as NSCopying)
     dictParams.setObject(txtLastName.text!, forKey: "Lastname" as NSCopying)
     //        dictParams.setObject(txtRafarralCode.text!, forKey: "ReferralCode" as NSCopying)
     dictParams.setObject("", forKey: "ReferralCode" as NSCopying)
     //        dictParams.setObject("1\(strPhoneNumber)", forKey: "MobileNo" as NSCopying)
     dictParams.setObject(strPhoneNumber, forKey: "MobileNo" as NSCopying)
     dictParams.setObject(strEmail, forKey: "Email" as NSCopying)
     dictParams.setObject(strPassword, forKey: "Password" as NSCopying)
     dictParams.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
     dictParams.setObject("1", forKey: "DeviceType" as NSCopying)
     dictParams.setObject(gender, forKey: "Gender" as NSCopying)
     if let registerContainer = self.navigationController?.childViewControllers[(self.navigationController?.childViewControllers.count as! Int) - 1] as? RegistrationContainerViewController {
     dictParams.setObject("\(registerContainer.CurrentLocation.coordinate.latitude)", forKey: "Lat" as NSCopying)
     dictParams.setObject("\(registerContainer.CurrentLocation.coordinate.longitude)", forKey: "Lng" as NSCopying)
     }
     dictParams.setObject(strDateOfBirth, forKey: "DOB" as NSCopying)

     var ProfileImage = UIImage()
     if self.isImageSelected == true {
     ProfileImage = self.imgProfile.image!
     }

     webserviceForRegistrationForUser(dictParams, image1:ProfileImage) { (result, status) in
     print(result)

     if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
     {

     DispatchQueue.main.async(execute: { () -> Void in

     //                    self.btnSignUp.stopAnimation(animationStyle: .normal, completion: {

     SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
     SingletonClass.sharedInstance.isUserLoggedIN = true
     SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)
     SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
     UserDefaults.standard.set(SingletonClass.sharedInstance.arrCarLists, forKey: "carLists")

     UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
     (UIApplication.shared.delegate as! AppDelegate).GoToHome()

     //                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
     //                    })
     })

     }
     else
     {
     //                self.btnSignUp.stopAnimation(animationStyle: .shake, revertAfterDelay: 0, completion: {

     UtilityClass.setCustomAlert(title: "", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
     }

     //                })
     }
     }
     }

     */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
