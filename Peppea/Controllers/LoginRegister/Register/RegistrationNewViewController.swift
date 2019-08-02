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
    var RegistrationGetOTPModel : RegistrationModel = RegistrationModel()
    @IBOutlet weak var txtFirstName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtLastName: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtDateOfBirth: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtRafarralCode: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtAddress: ThemeTextFieldLoginRegister!
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
 
        gender = "male"
        selectGender.first?.tintColor = ThemeColor
        selectGender.last?.tintColor = ThemeColor

    }



    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnProfileImage.layer.cornerRadius = self.btnProfileImage.frame.size.width/2
        self.btnProfileImage.layer.masksToBounds = true
        self.btnProfileImage.contentMode = .scaleAspectFit

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
            gender = "Male"
        }
        else if (sender.tag == 2) // Female
        {
            didSelectMale = false
            gender = "Female"
        }

    }

    // MARK: - Pick Image
    func TapToProfilePicture()
    {

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

        }
        else if self.txtAddress.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {

            isValid = false
            ValidatorMessage = "Please enter address."

        }
        else if self.strDateOfBirth == "" {
            
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
            webServiceCallForRegister()
        }
        else
        {
            UtilityClass.showAlert(title: "", message: Validator.1, alertTheme: .error)
        }
    }


    

     // MARK: - WebserviceCall

     func webServiceCallForRegister()
     {
        

        RegistrationGetOTPModel.email = SingletonRegistration.sharedRegistration.Email
        RegistrationGetOTPModel.mobile_no = SingletonRegistration.sharedRegistration.MobileNo
        RegistrationGetOTPModel.password = SingletonRegistration.sharedRegistration.Password
        RegistrationGetOTPModel.first_name = txtFirstName.text ?? ""
        RegistrationGetOTPModel.last_name = txtLastName.text ?? ""
        RegistrationGetOTPModel.RefarralCode = txtRafarralCode.text ?? ""
        RegistrationGetOTPModel.dob = txtDateOfBirth.text ?? ""
        RegistrationGetOTPModel.gender = gender
        RegistrationGetOTPModel.device_type = "ios"
        RegistrationGetOTPModel.lat = "23.75821"
        RegistrationGetOTPModel.lng = "23.75821"
        RegistrationGetOTPModel.device_token = ""
        if let token = UserDefaults.standard.object(forKey: "Token") as? String
        {
            RegistrationGetOTPModel.device_token = token
        }
        RegistrationGetOTPModel.address = txtAddress.text ?? ""
        
        if let vc = self.parent as? RegisterContainerViewController
        {
            vc.webServiceCallForRegister(RegistrationGetOTPModel, image: self.btnProfileImage.imageView!.image!)
        }

    }

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
