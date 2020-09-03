//
//  ProfileViewController.swift
//  Peppea
//
//  Created by eww090 on 09/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SDWebImage


class ProfileViewController: BaseViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblMobile: UILabel!
    var isImageSelected:Bool = false
    @IBOutlet var selectGender: [UIImageView]!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDOB: SkyFloatingLabelTextField!
    
    @IBOutlet weak var imgIndividual: UIImageView!
    @IBOutlet weak var imgRegisterAsCompany: UIImageView!
    @IBOutlet weak var imgRegisterUnderCompany: UIImageView!
    
    var gender = String()
    
//    var loginModelDetails: LoginModel = LoginModel()
    var loginModelDetails : LoginModel = LoginModel()
    var registerModelDetails : RegisterResponseModel = RegisterResponseModel()
    var updateProfile : UpdatePersonalInfo = UpdatePersonalInfo()
    var strDateOfBirth = String()
    
    @IBOutlet weak var iconRadioMale: UIImageView!
    
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var iconRadioFemale: UIImageView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var imgvMale: UIImageView!
    @IBOutlet weak var imgvFemale: UIImageView!
    
    var didSelectMale: Bool = true
    {
        didSet
        {
            if(didSelectMale)
            {
//                selectGender.first?.image = UIImage(named: "SelectedCircle")
//                selectGender.last?.image = UIImage(named: "UnSelectedCircle")
//
                imgvMale.image = UIImage(named: "SelectedCircle")
                imgvFemale.image = UIImage(named: "UnSelectedCircle")
            }
            else
            {
//                selectGender.first?.image = UIImage(named: "UnSelectedCircle")
//                selectGender.last?.image = UIImage(named: "SelectedCircle")

                imgvMale.image = UIImage(named: "UnSelectedCircle")
                imgvFemale.image = UIImage(named: "SelectedCircle")
            }
        }
    }

    var isComingFromPeppeaRentalFlow = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gender = "male"
        self.btnMale.isSelected = true
//        self.iconRadioMale.image = UIImage.init(named: "SelectedCircle")
//        self.iconRadioFemale.image = UIImage.init(named: "UnSelectedCircle")
        
        selectGender.first?.tintColor = ThemeColor
        selectGender.last?.tintColor = ThemeColor
        
        self.setNavBarWithBack(Title: "Profile", IsNeedRightButton: false)
        
        if isComingFromPeppeaRentalFlow {
            ///To make navigation bar title not capital
            self.navigationItem.title = "Profile"
        }
        
         txtFirstName.titleFormatter = { $0 }
         txtLastName.titleFormatter = { $0 }
         txtAddress.titleFormatter = { $0 }
         txtMobile.titleFormatter = { $0 }
         txtDOB.titleFormatter = { $0 }
        
        if(UserDefaults.standard.object(forKey: "userProfile") == nil)
        {
            return
        }
        
        do {
            loginModelDetails = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile")!
        } catch {
            AlertMessage.showMessageForError("error")
            return
        }
        setData()
    }
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.frame.size.width/2
        self.btnProfilePic.layer.masksToBounds = true
        self.btnProfilePic.contentMode = .scaleAspectFill
    }
    func setData()
    {
        btnProfilePic.layer.borderWidth = 3.0
        btnProfilePic.layer.borderColor = UIColor.lightGray.cgColor
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
        let profile = loginModelDetails.loginData
        lblEmail.text = profile!.firstName + " " + profile!.lastName
        lblMobile.text = profile?.email
        
        txtFirstName.text = profile?.firstName
        txtLastName.text = profile?.lastName
        txtAddress.text = profile?.address
        txtMobile.text = profile?.mobileNo
        txtDOB.text = profile?.dob
        
        if profile?.gender.lowercased() == "male" {
            didSelectMale = true
            gender = "male"
        } else {
            didSelectMale = false
            gender = "female"
        }
        let strImage = NetworkEnvironment.baseImageURL + profile!.profileImage
        btnProfilePic.sd_setImage(with: URL(string: strImage), for: .normal, placeholderImage: UIImage(named: "imgProfilePlaceHolder"))

        btnProfilePic.layer.borderColor = UIColor.lightGray.cgColor
        btnProfilePic.layer.borderWidth = 3
        btnProfilePic.layer.masksToBounds = true
        
        imgIndividual.image = UIImage(named: "UnSelectedCircle")
        imgRegisterAsCompany.image = UIImage(named: "UnSelectedCircle")
        imgRegisterUnderCompany.image = UIImage(named: "UnSelectedCircle")
        
        if profile?.userType == "individual" {
            imgIndividual.image = UIImage(named: "SelectedCircle")
            
        }else if profile?.userType == "under_company"{
           
            imgRegisterUnderCompany.image = UIImage(named: "SelectedCircle")
        }else{
           
            imgRegisterAsCompany.image = UIImage(named: "SelectedCircle")
        }
        
        imgIndividual.setImageColor(color: ThemeColor)
        imgRegisterAsCompany.setImageColor(color: ThemeColor)
        imgRegisterUnderCompany.setImageColor(color: ThemeColor)
    }

    @IBAction func btnIndividual(_ sender: UIButton) {
    }
    
    @IBAction func btnRegisterAsCompanyAction(_ sender: UIButton) {
    }
    
    @IBAction func btnRegisterUnderCompanyAction(_ sender: UIButton) {
    }
    
    
    @IBAction func btnSaveClicked(_ sender: Any)
    {
        updateProfile.first_name = txtFirstName.text ?? ""
        updateProfile.last_name = txtLastName.text ?? ""
        updateProfile.address = txtAddress.text ?? ""
        updateProfile.dob = txtDOB.text ?? ""
        updateProfile.gender = gender
        
        if(self.validations().0 == false)
        {
            AlertMessage.showMessageForError(self.validations().1)
        }
        else
        {
            self.webserviceForUpdateProfile(updateProfile: updateProfile, image: self.btnProfilePic.imageView!.image!)
        }
    }
    func validations() -> (Bool,String)
    {
        
        if(updateProfile.first_name.isBlank)
        {
            return (false,"Please enter first name")
        }
        else if(updateProfile.last_name.isBlank)
        {
            return (false,"Please enter last name")
        }
        else if(updateProfile.dob.isBlank)
        {
            return (false,"Please enter date of birth")
        }
        else if(updateProfile.address.isBlank)
        {
            return (false,"Please enter address")
        }
        return (true,"")
    }

    func webserviceForUpdateProfile(updateProfile : UpdatePersonalInfo, image : UIImage)
    {
        UtilityClass.showHUD(with: UIApplication.shared.keyWindow)
        let profile = loginModelDetails.loginData
        
        updateProfile.customer_id = profile!.id
        UserWebserviceSubclass.updatePersonal(updateProfile: updateProfile, image: image, imageParamName: "profile_image") { (json, status) in
            
            
            UtilityClass.hideHUD()
            
            if status{
                
                let registerModelDetails = LoginModel.init(fromJson: json)
                do
                {
                    try UserDefaults.standard.set(object: registerModelDetails, forKey: "userProfile")//(loginModelDetails, forKey: "userProfile")
                    SingletonClass.sharedInstance.walletBalance = registerModelDetails.loginData.walletBalance
                    self.lblEmail.text = registerModelDetails.loginData.firstName + " " + registerModelDetails.loginData.lastName
                    self.lblMobile.text = registerModelDetails.loginData.mobileNo
                    AlertMessage.showMessageForSuccess(json["message"].stringValue)
                    self.navigationController?.popViewController(animated: true)
                }
                catch
                {
                    AlertMessage.showMessageForError("error")
                }
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }

     
    }
    
    @IBAction func btnProfilePicClicked(_ sender: Any)
    {
        self.TapToProfilePicture()
    }
    
    @IBAction func btnMaleClicked(_ sender: UIButton)
    {

        if(sender.tag == 1) // Male
        {
             gender = "male"
            didSelectMale = true
        }
        else if (sender.tag == 2) // Female
        {
             gender = "female"
            didSelectMale = false
        }
    }
    @IBAction func btnFemaleClicked(_ sender: Any)
    {
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
//        picker.mediaTypes = [kUTTypeImage as String]
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
            btnProfilePic.imageView?.contentMode = .scaleToFill
            btnProfilePic.setImage(pickedImage, for: .normal)
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
        txtDOB.text = dateFormaterView.string(from: sender.date)
        strDateOfBirth = txtDOB.text!
    }
    
    @IBAction func btnChangePasswordClicked(_ sender: Any)
    {
        let storyborad = UIStoryboard(name: "LoginRegister", bundle: nil)
        let ChangePwVC = storyborad.instantiateViewController(withIdentifier: "ChangePwVC") as! ChangePwVC
        self.navigationController?.pushViewController(ChangePwVC, animated: true)
    }
    
}

