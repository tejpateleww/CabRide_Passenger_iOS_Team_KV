//
//  ProfileViewController.swift
//  Peppea
//
//  Created by eww090 on 09/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


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
    
    var strDateOfBirth = String()
    
    @IBOutlet weak var iconRadioMale: UIImageView!
    
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var iconRadioFemale: UIImageView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
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

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.btnMale.isSelected = true
//        self.iconRadioMale.image = UIImage.init(named: "SelectedCircle")
//        self.iconRadioFemale.image = UIImage.init(named: "UnSelectedCircle")
        
        selectGender.first?.tintColor = ThemeColor
        selectGender.last?.tintColor = ThemeColor
        
        self.setNavBarWithBack(Title: "Profile", IsNeedRightButton: false)
        
         txtFirstName.titleFormatter = { $0 }
         txtLastName.titleFormatter = { $0 }
         txtAddress.titleFormatter = { $0 }
         txtMobile.titleFormatter = { $0 }
         txtDOB.titleFormatter = { $0 }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.frame.size.width/2
        self.btnProfilePic.layer.masksToBounds = true
        self.btnProfilePic.contentMode = .scaleAspectFill
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSaveClicked(_ sender: Any)
    {
        
    }

    
    @IBAction func btnProfilePicClicked(_ sender: Any)
    {
        self.TapToProfilePicture()
    }
    
    @IBAction func btnMaleClicked(_ sender: UIButton)
    {
//        self.iconRadioMale.image = UIImage.init(named: "SelectedCircle")
//        self.iconRadioFemale.image = UIImage.init(named: "UnSelectedCircle")
        if(sender.tag == 1) // Male
        {
            didSelectMale = true
        }
        else if (sender.tag == 2) // Female
        {
            didSelectMale = false
        }
    }
    @IBAction func btnFemaleClicked(_ sender: Any)
    {
//        self.iconRadioFemale.image = UIImage.init(named: "SelectedCircle")
//        self.iconRadioMale.image = UIImage.init(named: "UnSelectedCircle")
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
